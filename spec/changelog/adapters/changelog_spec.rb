require 'rspec'
require 'spec_helper'

describe MetaCommit::Changelog::Adapters::Changelog do
  describe '#write_repository_change_chunk' do
    subject do
      MetaCommit::Changelog::Adapters::Changelog.new('path', 'filename', 'tag', 'date')
    end
    let(:message_builder) { double(:message_builder, :build => '') }
    before do
      expect(subject).to receive(:changelog_message_builder).and_return(message_builder)
    end
    it 'adds all changes to builder' do
      expect(File).to receive(:read).and_return('')
      file_to_write = double(:file)
      expect(file_to_write).to receive(:write)
      expect(File).to receive(:open).and_return(file_to_write)

      diffs = [
          double(:diff1, {:type_addition? => true, :type_deletion? => false, :type_replace? => false, :string_representation => ''}),
          double(:diff2, {:type_addition? => false, :type_deletion? => true, :type_replace? => false, :string_representation => ''}),
          double(:diff3, {:type_addition? => false, :type_deletion? => false, :type_replace? => true, :string_representation => ''}),
      ]
      expect(message_builder).to receive(:add_to_added).once
      expect(message_builder).to receive(:add_to_removed).once
      expect(message_builder).to receive(:add_to_changed).once

      subject.write_repository_change_chunk(nil, diffs)
    end
    it 'writes to file builder message with previous content' do
      expect(File).to receive(:read).and_return('previous content')
      file_to_write = double(:file)
      contains_both_strings = Regexp.union([/previous content/, /builder message]/])
      expect(file_to_write).to receive(:write).with(contains_both_strings)
      expect(File).to receive(:open).and_return(file_to_write)

      expect(message_builder).to receive(:build).and_return('builder message')

      subject.write_repository_change_chunk(nil, [])
    end
  end
end