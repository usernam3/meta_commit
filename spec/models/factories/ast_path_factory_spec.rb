require 'rspec'

describe MetaCommit::Models::Factories::AstPathFactory do
  describe '#create_ast_path' do
    it 'returns empty ast path when empty ast passed' do
      ast_content = ''
      source_ast = Parser::CurrentRuby.parse(ast_content)
      ast_path = subject.create_ast_path(source_ast, 2)

      expect(ast_path).to be_a(MetaCommit::Models::AstPath)
      expect(ast_path.ast).to be nil
      expect(ast_path.path).to be_empty
    end
    it 'returns nil when ast not found' do
      ast_content = <<-eos
module TestModule
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      ast_path = subject.create_ast_path(source_ast, 3)

      expect(ast_path).to be_a(MetaCommit::Models::AstPath)
      expect(ast_path.ast).to be nil
      expect(ast_path.path).to be_empty
    end
    it 'returns lowest level ast on line' do
      ast_content = <<-eos
module TestModule;end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      ast_path = subject.create_ast_path(source_ast, 1)

      expect(ast_path).to be_a(MetaCommit::Models::AstPath)
      expect(ast_path.ast).to eq(source_ast.children.first)
    end
    it 'builds ast path from complex source ast' do
      ast_content = <<-eos
module TestModule
  module NestedTestModule
    module MoreNestedTestModule
    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      ast_path = subject.create_ast_path(source_ast, 3)

      expect(ast_path).to be_a(MetaCommit::Models::AstPath)
      expect(ast_path.ast).to eq(source_ast.children.last.children.last.children.first)
    end
    it 'adds every level of passed ast to path' do
      ast_content = <<-eos
module TestModule
  module NestedTestModule
    module MoreNestedTestModule
    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      ast_path = subject.create_ast_path(source_ast, 3)

      expect(ast_path).to be_a(MetaCommit::Models::AstPath)
      expect(ast_path.path).to eq([
                                     source_ast,
                                     source_ast.children.last,
                                     source_ast.children.last.children.last,
                                     source_ast.children.last.children.last.children.first,
                                 ])
    end
  end
end