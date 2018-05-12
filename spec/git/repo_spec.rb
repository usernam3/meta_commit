require 'rspec'

describe MetaCommit::Git::Repo do
  describe '#initialize' do
    it 'creates repository if passed path is git repo' do
      current_folder_path = File.join(File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__)))))
      repo = MetaCommit::Git::Repo.new(current_folder_path)

      expect(repo.repo).to be_instance_of Rugged::Repository
    end
    it 'throws exception if passed path does not exist' do
      expect {MetaCommit::Git::Repo.new('')}.to raise_error(MetaCommit::Errors::MissingRepoError)
    end
    it 'throws exception if passed path is not git repo' do
      current_folder_path = File.join(File.expand_path(File.dirname(File.dirname(__FILE__))))

      expect {MetaCommit::Git::Repo.new(current_folder_path)}.to raise_error(MetaCommit::Errors::MissingRepoError)
    end
  end
  describe '#walker' do
    skip
  end
  describe '#walk_by_commits' do
    skip
  end
  describe '#index_diff' do
    skip
  end
  describe '#get_blob_at' do
    skip
  end
  describe '#get_content_of' do
    skip
  end
  describe '#dir' do
    skip
  end
  describe '#commit_of_tag' do
    skip
  end
  describe '#last_commit_oid' do
    skip
  end
end