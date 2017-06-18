module MetaCommit::Models::Changes
  class File
    attr_accessor :old_file_path, :new_file_path, :changes

    def initialize(old_file_path, new_file_path)
      @old_file_path = old_file_path
      @new_file_path = new_file_path
      @changes = []
    end

    def push(change)
      @changes.push(change)
    end

    def file_path
      if @new_file_path == @new_file_path
        @new_file_path
      else
        "#{@old_file_path} -> #{@new_file_path}"
      end
    end

    def each(&block)
      @changes.each(&block)
    end
  end
end
