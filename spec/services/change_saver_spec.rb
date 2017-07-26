require 'rspec'

describe MetaCommit::Services::ChangeSaver do
  describe '#store_meta' do
    it 'saves meta from repo using adapter' do
      repo = double(:repo)
      adapter = double(:adapter)
      repo_changes = double(:repo_changes)

      expect(adapter).to receive(:write_repository_change_chunk).with(repo, repo_changes).once

      service = MetaCommit::Services::ChangeSaver.new(repo, adapter)
      service.store_meta(repo_changes)
    end
  end
end