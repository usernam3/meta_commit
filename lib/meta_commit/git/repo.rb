require 'rugged'

module MetaCommit::Git
  # Rugged::Repository wrapper
  # @attr [Rugged::Repository] repo
  class Repo
    DIFF_OPTIONS = {:context_lines => 0, :ignore_whitespace => true}
    INDEX_DIFF_OPTIONS = {:context_lines => 0, :ignore_whitespace => true, :reverse => true}

    FILE_NOT_EXISTS_OID = '0000000000000000000000000000000000000000'

    attr_accessor :repo

    # @param [String] repo_path
    def initialize(repo_path)
      begin
        @repo = Rugged::Repository.new(repo_path)
      rescue Rugged::OSError
        raise MetaCommit::Errors::MissingRepoError
      rescue Rugged::RepositoryError
        raise MetaCommit::Errors::MissingRepoError
      end
    end

    # @return [Rugged::Walker] commit iterator
    def walker
      walker = Rugged::Walker.new(@repo)
      walker.sorting(Rugged::SORT_REVERSE)
      walker.push(@repo.last_commit.oid)
      walker
    end

    # Starts commit walker and yields following commits for easier iteration
    # @yield [previous_commit, current_commit]
    def walk_by_commits
      walker = Rugged::Walker.new(@repo)
      walker.sorting(Rugged::SORT_REVERSE)
      walker.push(@repo.last_commit.oid)
      previous_commit = nil
      walker.each do |current_commit|
        # skip first commit
        previous_commit = current_commit if previous_commit.nil?
        next if previous_commit == current_commit
        yield(previous_commit, current_commit)
        previous_commit = current_commit
      end
    end

    # Proxy to Rugged::Repository#diff
    # @param [Object] left
    # @param [Object] right
    # @param [Hash] options
    # @return [Rugged::Diff::Delta]
    def diff(left, right, options)
      @repo.diff(left, right, options)
    end

    # Iterates over optimized lines in diff
    # @param [Object] left
    # @param [Object] right
    # @yield [old_file_path, new_file_path, patch, line]
    # @return [Object]
    def diff_with_optimized_lines(left, right)
      diff = @repo.diff(left, right, DIFF_OPTIONS)
      diff.deltas.zip(diff.patches).each do |delta, patch|
        lines = organize_lines(delta, patch)
        lines.each do |line|
          yield(delta.old_file[:path], delta.new_file[:path], patch, line)
        end
      end
    end

    # Iterates over optimized lines in index diff
    # @yield [old_file_path, new_file_path, patch, line]
    # @return [Object]
    def index_diff_with_optimized_lines
      diff = index_diff(INDEX_DIFF_OPTIONS)
      diff.deltas.zip(diff.patches).each do |delta, patch|
        lines = organize_lines(delta, patch)
        lines.each do |line|
          yield(delta.old_file[:path], delta.new_file[:path], patch, line)
        end
      end
    end

    # Proxy to Rugged::Index#diff
    # @param [Hash] options
    # @return [Rugged::Diff::Delta]
    def index_diff(options)
      @repo.index.diff(@repo.head.target.tree, options)
    end

    # @param [String] revision commit hash
    # @param [String] path
    # @param [String] default value to be returned if error appears
    def get_blob_at(revision, path, default = nil)
      blob = @repo.blob_at(revision, path)
      return blob.content unless blob.nil?
      default
    end

    # @param [String] rel_repo_file_path file path relative to repository root
    # @param [String] default value to be returned if error appears
    # @return [String] file content or default value
    def get_content_of(rel_repo_file_path, default = nil)
      absolute_file_path = dir + rel_repo_file_path
      begin
        content = open(absolute_file_path).read
      rescue Errno::ENOENT
        content = default
      end
      content
    end

    # @return [String] path to .git folder of repository
    def path
      @repo.path
    end

    # @return [String] directory of repository
    def dir
      @repo.path.reverse.sub('/.git'.reverse, '').reverse
    end

    # @param [String] search_tag
    # @return [Rugged::Commit, nil]
    def commit_of_tag(search_tag)
      @repo.tags.each do |tag|
        return tag.target if tag.name == search_tag
      end
    end

    # @return [String] last commit oid
    def last_commit_oid
      @repo.last_commit.oid
    end

    # @param [Object] delta
    # @param [Object] patch
    # @return [Array<MetaCommit::Models::Line>]
    def organize_lines(delta, patch)
      lines_to_walk = []
      # if whole file was changed examine one time only
      whole_file_changed = (delta.old_file[:oid] == FILE_NOT_EXISTS_OID) || (delta.new_file[:oid] == FILE_NOT_EXISTS_OID)
      skip_walking = false
      skip_next_line = false
      patch.hunks.each_with_index do |hunk|
        break if skip_walking
        hunk.lines.each_with_index do |line, line_index|
          break if skip_walking

          if skip_next_line
            skip_next_line = false
            next
          end

          next_line = hunk.lines[line_index + 1]
          is_replace_change = (line.deletion?) && (!next_line.nil? && next_line.addition?) && (line.old_lineno && next_line.new_lineno)

          line_to_walk = MetaCommit::Models::Line.new
          if is_replace_change
            line_to_walk.line_origin=:replace
            line_to_walk.old_lineno=line.old_lineno
            line_to_walk.new_lineno=next_line.new_lineno
          else
            line_to_walk.line_origin=line.line_origin
            line_to_walk.old_lineno=line.old_lineno
            line_to_walk.new_lineno=line.new_lineno
          end
          if is_replace_change
            skip_next_line = true
          end
          lines_to_walk.push(line_to_walk)

          skip_walking = true if whole_file_changed
        end
      end
      lines_to_walk
    end

    private :organize_lines

  end
end