module MetaCommit::Models::Changes
  # Collection of commit changes
  # @attr [String] repo_id
  # @attr [Array<MetaCommit::Models::Commit>] commit_changes
  class Repository
    attr_accessor :repo_id, :commit_changes

    # @param [String] repo_id
    def initialize(repo_id)
      @repo_id = repo_id
      @commit_changes = []
    end


    # @param [MetaCommit::Models::Commit] commit_change
    def push(commit_change)
      @commit_changes.push(commit_change)
    end

    # @yield commit changes
    def each(&block)
      @commit_changes.each(&block)
    end

    # @return [Boolean]
    def empty?
      @commit_changes.empty?
    end
  end
end
