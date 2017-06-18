module MetaCommit::Services
  class ChangeSaver
    attr_accessor :repo

    def initialize(repo)
      @repo = repo
    end

    def meta_adapter
      # @TODO fetch adapter from config
      MetaCommit::Adapters::GitNotes.new(@repo.repo.path)
    end

    def store_meta(changes_of_repo)
      store_repository_changes(changes_of_repo)
    end

    def store_repository_changes(changes_of_repo)
      meta_adapter.write_repository_change_chunk(repo, changes_of_repo)
    end

    def store_commit_changes(changes_of_commit)
      meta_adapter.write_commit_change_chunk(repo.repo, changes_of_repo, changes_of_commit)
      changes_of_commit.each do |changes_of_file|
        store_file_changes(changes_of_file)
      end
    end

    def store_file_changes(changes_of_file)
      meta_adapter.write_file_change_chunk(changes_of_file)
      uniques_file_changes = changes_of_file.changes.uniq { |diff| diff.to_s }
      uniques_file_changes.each do |diff|
        store_diff(diff)
      end
    end

    def store_diff(diff)
      meta_adapter.write_diff(diff)
    end
  end
end