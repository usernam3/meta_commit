require 'spec_helper'

describe MetaCommit::Models::Changes::Commit do
  describe '#initialize' do
    it 'stores commit ids' do
      commit_changes = MetaCommit::Models::Changes::Commit.new(:old_id, :new_id)

      expect(commit_changes.old_commit_id).to be == :old_id
      expect(commit_changes.new_commit_id).to be == :new_id
    end
  end
  describe '#push' do
    it 'accumulates changes' do
      change = double(:change_1)
      commit_changes = MetaCommit::Models::Changes::Commit.new(:old_id, :new_id)

      commit_changes.push(change)

      expect(commit_changes.empty?).to be_falsey
      expect(commit_changes.include?(change)).to be_truthy
    end
  end
  describe '#push_changes' do
    it 'adds multiple changes' do
      change = double(:change_1)
      commit_changes = MetaCommit::Models::Changes::Commit.new(:old_id, :new_id)

      commit_changes.push_changes([change])

      expect(commit_changes.empty?).to be_falsey
      expect(commit_changes.include?(change)).to be_truthy
    end
  end
  describe '#commit_id' do
    it 'returns one commit id if they are same' do
      commit_changes = MetaCommit::Models::Changes::Commit.new(:commit_id, :commit_id)

      expect(commit_changes.commit_id).to be == :commit_id
    end
    it 'returns both commit ids if they are different' do
      commit_changes = MetaCommit::Models::Changes::Commit.new(:old_id, :new_id)

      commit_id = commit_changes.commit_id

      expect(commit_id).to include('old_id')
      expect(commit_id).to include('new_id')
    end
  end
  describe '#each' do
    it 'yields each change' do
      change1 = double(:change_1)
      change2 = double(:change_2)
      commit_changes = MetaCommit::Models::Changes::Commit.new(:old_id, :new_id)

      commit_changes.push_changes([change1, change2])

      expect {|b| commit_changes.each(&b)}.to yield_successive_args(change1, change2)
    end
  end
end