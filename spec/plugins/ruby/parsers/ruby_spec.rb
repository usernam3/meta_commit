require 'rspec'

describe MetaCommit::Plugin::Ruby::Parsers::Ruby do
  describe '#supported_file_extensions' do
    it 'supports ruby files' do
      expect(subject.class.supported_file_extensions).to include('rb')
    end
  end
  describe '#supports_syntax?' do
    it 'supports ruby syntax' do
      expect(subject.class.supports_syntax?('def true!; 2 + 2 == 5 end')).to be_truthy
    end
    it 'does not support other syntax' do
      expect(subject.class.supports_syntax?('|> not ruby code at all')).to be_falsey
    end
  end
  describe '#parse' do
    it 'raise error when receives not ruby code' do
      expect {subject.parse('|> not ruby code at all')}.to raise_error(MetaCommit::Contracts::Errors::SourceCodeParsingError)
    end
    it 'parses code to Ast' do
      parsed = subject.parse('def block_of; "ruby code" end')

      expect(parsed).to be_instance_of MetaCommit::Plugin::Ruby::Models::Ast
    end
  end
end