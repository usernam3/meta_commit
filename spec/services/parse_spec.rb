require 'rspec'

describe MetaCommit::Services::Parse do
  describe '#execute' do
    let(:file_path) {'file_path'}
    let(:content) {'content'}
    it 'returns nil when parser factory does not provide parser' do
      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content)

      MetaCommit::Services::Parse.new(factory).execute(file_path, content)
    end
    it 'sends content to provided parser' do
      parser = double(:parser)
      expect(parser).to receive(:parse).with(content).and_return(MetaCommit::Contracts::Ast.new)

      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content).and_return(parser)

      MetaCommit::Services::Parse.new(factory).execute(file_path, content)
    end
    it 'returns parsed data with parser class print' do
      parser = double(:parser, :class => :foo_class)
      parsed_ast = MetaCommit::Contracts::Ast.new
      expect(parser).to receive(:parse).with(content).and_return(parsed_ast)

      factory = double(:factory)
      expect(factory).to receive(:create_parser_for).with(file_path, content).and_return(parser)

      actual_parsed_ast = MetaCommit::Services::Parse.new(factory).execute(file_path, content)
      expect(actual_parsed_ast).to be(parsed_ast)
      expect(actual_parsed_ast.parser_class).to be(:foo_class)
    end
  end
end