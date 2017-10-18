require 'spec_helper'

describe MetaCommit::Models::Changes::Repository do
  describe '#initialize' do
    it 'stores repo id' do
      repository_changes = MetaCommit::Models::Changes::Repository.new(:repo_id)

      expect(repository_changes.repo_id).to be == :repo_id
    end
  end
  describe '#push' do
    it 'accumulates changes' do
      change = double(:change_1)
      repository_changes = MetaCommit::Models::Changes::Repository.new(:repo_id)

      repository_changes.push(change)

      expect(repository_changes.empty?).to be_falsey
    end
  end
  describe '#each' do
    it 'yields each change' do
      change1 = double(:change_1)
      change2 = double(:change_2)
      repository_changes = MetaCommit::Models::Changes::Repository.new(:repo)

      repository_changes.push(change1)
      repository_changes.push(change2)

      expect {|b| repository_changes.each(&b)}.to yield_successive_args(change1, change2)
    end
  end
end