require 'rspec'
require 'spec_helper'

describe MetaCommit::Message::Formatters::CommitMessageBuilder do
  describe '#build' do
    it 'returns string that contains messages' do
      diff1 = double(:diff1, {:string_representation => 'diff1'})
      diff2 = double(:diff2, {:string_representation => 'diff2'})

      build_result = subject.build([diff1, diff2,])
      expect(build_result).to include 'diff1'
      expect(build_result).to include 'diff2'
    end
  end
end