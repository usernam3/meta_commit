module MetaCommit::Services
  class ChangeSaver
    attr_accessor :repo, :meta_adapter

    def initialize(repo, meta_adapter)
      @repo = repo
      @meta_adapter = meta_adapter
    end

    def store_meta(changes_of_repo)
      store_repository_changes(changes_of_repo)
    end

    def store_repository_changes(changes_of_repo)
      meta_adapter.write_repository_change_chunk(repo, changes_of_repo)
    end
  end
end