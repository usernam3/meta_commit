require 'rspec'

describe MetaCommit::Plugin::Ruby::Models::Ast do
  describe '#ast' do
    it 'returns passed ast' do
      mock = double(:ast)

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.ast).to be mock
    end
  end
  describe '#children' do
    it 'returns array with children nodes of passed ast' do
      mock = double(:ast, :children => [double(:child1), double(:child2),])

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.children).to be_an_instance_of(Array)
      expect(ast.children).to all(be_a(MetaCommit::Contracts::Ast))
      expect(ast.children.length).to be 2
    end
  end
  describe '#first_line' do
    it 'returns first line number of ast location' do
      mock = double(:ast, :location => double(:first_line => 42))

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.first_line).to be 42
    end
    it 'returns nil when ast does not have location' do
      mock = double(:ast)

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.first_line).to be nil
    end
    it 'returns nil when ast is Parser::Source::Map::Collection' do
      mock = class_double(Parser::Source::Map::Collection)

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.first_line).to be nil
    end
  end
  describe '#last_line' do
    it 'returns last line number of ast location' do
      mock = double(:ast, :location => double(:last_line => 42))

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.last_line).to be 42
    end
    it 'returns nil when ast does not have location' do
      mock = double(:ast)

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.last_line).to be nil
    end
    it 'returns nil when ast is Parser::Source::Map::Collection' do
      mock = class_double(Parser::Source::Map::Collection)

      ast = MetaCommit::Plugin::Ruby::Models::Ast.new(mock)

      expect(ast.last_line).to be nil
    end
  end
end