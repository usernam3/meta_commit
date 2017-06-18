module MetaCommit::Adapters
  class Dump
    attr_accessor :repository, :commit, :file

    def initialize

    end

    def write_repository_change_chunk(repository_change)
      puts '---'
      puts "repo id: #{repository_change.repo_id}"
      puts '---'
    end

    def write_commit_change_chunk(commit_change)
      puts "> commit : #{commit_change.commit_id}"
    end

    def write_file_change_chunk(file_change)
      puts "file : #{file_change.file_path}"
    end

    def write_diff(diff)
      puts " - #{diff}"
    end

    def write_lines

    end
  end
end