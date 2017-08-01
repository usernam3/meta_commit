require 'rspec'
require 'spec_helper'

describe MetaCommit::Services::Parse do
  describe '#execute' do
    let(:file_path) { 'file_path' }
    let(:content) { 'content' }
    it 'returns nil when parser factory does not provide parser' do
      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content)

      MetaCommit::Services::Parse.new(factory).execute(file_path, content)
    end
    it 'sends content to provided parser' do
      parser = double(:parser)
      expect(parser).to receive(:parse).with(content)

      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content).and_return(parser)

      MetaCommit::Services::Parse.new(factory).execute(file_path, content)
    end
    it 'returns parsed data' do
      parser = double(:parser)
      expect(parser).to receive(:parse).with(content).and_return(:parsed_data)

      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content).and_return(parser)

      expect(MetaCommit::Services::Parse.new(factory).execute(file_path, content)).to be(:parsed_data)
    end
  end
end