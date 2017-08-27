module MetaCommit::Models::Changes
  class Repository
    attr_accessor :repo_id, :commit_changes

    def initialize(repo_id)
      @repo_id = repo_id
      @commit_changes = []
    end

    def push(commit_change)
      @commit_changes.push(commit_change)
    end

    def each(&block)
      @commit_changes.each(&block)
    end

    # @return [Boolean]
    def empty?
      @commit_changes.empty?
    end
  end
end
