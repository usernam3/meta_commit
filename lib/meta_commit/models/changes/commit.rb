module MetaCommit::Models::Changes
  # Collection of file changes
  # @attr [Symbol] old_commit_id
  # @attr [Symbol] new_commit_id
  # @attr [Array<MetaCommit::Contracts::Diff>] file_changes
  class Commit
    attr_accessor :old_commit_id, :new_commit_id, :file_changes

    # @param [Symbol] old_commit_id
    # @param [Symbol] new_commit_id
    def initialize(old_commit_id, new_commit_id)
      @old_commit_id = old_commit_id
      @new_commit_id = new_commit_id
      @file_changes = []
    end

    # @param [MetaCommit::Contracts::Diff] file_change
    def push(file_change)
      @file_changes.push(file_change)
    end

    # @param [Array<MetaCommit::Contracts::Diff>] file_changes
    def push_changes(file_changes)
      @file_changes+=file_changes
    end

    # @return [String]
    def commit_id
      if @old_commit_id == @new_commit_id
        @new_commit_id
      else
        "#{@old_commit_id} -> #{@new_commit_id}"
      end
    end

    # @yield file changes
    def each(&block)
      @file_changes.each(&block)
    end

    # @return [Boolean]
    def empty?
      @file_changes.empty?
    end

    # @return [Boolean]
    def include?(change)
      @file_changes.include?(change)
    end
  end
end
