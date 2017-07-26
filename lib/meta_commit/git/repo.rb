require 'rugged'

module MetaCommit::Git
  class Repo
    attr_accessor :repo

    def initialize(repo_path)
      @repo = Rugged::Repository.new(repo_path)
    end

    def walker
      walker = Rugged::Walker.new(@repo)
      walker.sorting(Rugged::SORT_REVERSE)
      walker.push(@repo.last_commit.oid)
      walker
    end

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

    def diff(left, right, options)
      @repo.diff(left, right, options)
    end

    def index_diff(options)
      @repo.index.diff(@repo.head.target.tree, options)
    end

    def get_blob_at(revision, path, default = nil)
      blob = @repo.blob_at(revision, path)
      return blob.content unless blob.nil?
      default
    end

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

    # @return [Rugged::Commit, nil]
    def commit_of_tag(search_tag)
      @repo.tags.each do |tag|
        return tag.target if tag.name == search_tag
      end
      nil
    end
  end
end