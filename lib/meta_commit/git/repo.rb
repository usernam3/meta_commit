require 'rugged'

module MetaCommit::Git
  # Rugged::Repository wrapper
  # @attr [Rugged::Repository] repo
  class Repo
    extend Forwardable

    DIFF_OPTIONS = {:context_lines => 0, :ignore_whitespace => true}
    INDEX_DIFF_OPTIONS = {:context_lines => 0, :ignore_whitespace => true, :reverse => true}

    FILE_NOT_EXISTS_OID = '0000000000000000000000000000000000000000'

    attr_accessor :repo
    def_delegators :@repo, :diff, :path

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

  end
end