require 'spec_helper'

describe MetaCommit::Index::Adapters::GitNotes do
  describe '#write_repository_change_chunk' do
    it 'passes arguments to git command' do
      repo = double(:repo)
      repo_changes = double(:repo_changes)
      commit_changes = double(:commit_changes, {:new_commit_id => 'new_commit_id', file_changes: [
          double(:change_1, {:string_representation => 'change_1'}),
          double(:change_2, {:string_representation => 'change_2'}),
      ]})
      expect(repo_changes).to receive(:each).and_yield(commit_changes)

      adapter = MetaCommit::Index::Adapters::GitNotes.new('git folder path')

      expect(adapter).to receive(:system).with(Regexp.union([/git/, /notes add/, /git folder path/]))

      adapter.write_repository_change_chunk(repo, repo_changes)
    end
    it 'writes unique commit changes' do
      repo = double(:repo)
      repo_changes = double(:repo_changes)
      commit_changes = double(:commit_changes, {:new_commit_id => 'new_commit_id', file_changes: [
          double(:change_1, {:string_representation => 'change_1'}),
          double(:change_2, {:string_representation => 'change_1'}),
          double(:change_3, {:string_representation => 'change_3'}),
      ]})
      expect(repo_changes).to receive(:each).and_yield(commit_changes)

      adapter = MetaCommit::Index::Adapters::GitNotes.new('git folder path')

      expect(adapter).to receive(:system).with(string_contains_single_occurrence_of('change_1'))

      adapter.write_repository_change_chunk(repo, repo_changes)
    end
  end
end