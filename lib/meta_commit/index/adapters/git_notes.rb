module MetaCommit::Index
  module Adapters
    # Adapter class to write repository changes to git notes
    # @attr [String] git_folder_path
    class GitNotes
      attr_accessor :git_folder_path

      # @param [String] git_folder_path
      def initialize(git_folder_path)
        @git_folder_path = git_folder_path
      end

      # @param [MetaCommit::Git::Repo] repo
      # @param [MetaCommit::Models::Changes::Repository] repository_changes
      def write_repository_change_chunk(repo, repository_changes)
        repository_changes.each do |commit_changes|
          diffs=[]
          commit_changes.file_changes.uniq.each do |change|
            diffs.push(" - #{change.string_representation}")
          end
          write_to_notes(commit_changes.new_commit_id, diffs.uniq.join("\n"))
        end
      end

      # @param [String] commit_id
      # @param [String] message
      def write_to_notes(commit_id, message)
        system("git --git-dir '#{@git_folder_path}' notes add -f -m '#{message}' #{commit_id}")
      end

      protected :write_to_notes
    end
  end
end