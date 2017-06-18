module MetaCommit::Adapters
  class GitNotes
    attr_accessor :repository, :commit, :file

    def initialize(repository)
      @repository = repository
    end

    def write_repository_change_chunk(repository, repository_changes)
      repository_changes.each do |commit_changes|
        diffs=[]
        commit_changes.each do |file_changes|
          uniques_file_changes = file_changes.changes.uniq { |diff| diff.to_s }
          uniques_file_changes.each do |diff|
            diffs.push(" - #{diff.string_representation}")
          end
        end
        write_to_notes(repository.path, commit_changes.new_commit_id, diffs.join("\n"))
      end
    end

    def write_to_notes(repo_path, commit_id, message)
      # @TODO escape command
      # @TODO add --ref=meta_commit
      system("git --git-dir '#{repo_path}' notes add -f -m '#{message}' #{commit_id}")
    end
  end
end