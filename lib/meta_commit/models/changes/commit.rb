module MetaCommit::Models::Changes
  class Commit
    attr_accessor :old_commit_id, :new_commit_id, :file_changes

    def initialize(old_commit_id, new_commit_id)
      @old_commit_id = old_commit_id
      @new_commit_id = new_commit_id
      @file_changes = []
    end

    def push(file_change)
      @file_changes.push(file_change)
    end

    def commit_id
      if @old_commit_id == @new_commit_id
        @new_commit_id
      else
        "#{@old_commit_id} -> #{@new_commit_id}"
      end
    end

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
