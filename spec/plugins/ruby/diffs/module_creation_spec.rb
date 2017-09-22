require 'rspec'

describe MetaCommit::Plugin::Ruby::Diffs::ModuleCreation do
  let(:type) { MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_ADDITION }
  let(:old_file_name) { 'old_file_name' }
  let(:new_file_name) { 'new_file_name' }
  let(:old_ast_path) { nil }

  describe '#supports_change' do
    it 'supports addition where ast is module definition' do
      ast_content = <<-eos
module TestModule
  class TestClass
    def test_method
    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 1)
      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
    it 'supports addition where ast is end of module definition' do
      ast_content = <<-eos
module TestModule
  class TestClass
    def test_method
    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 6)

      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
  end

  describe '#string_representation' do
    it 'prints change when ast is module' do
      ast_content = <<-eos
module TestModule
  class TestClass
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 1)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=nil
      subject.new_lineno=2
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('created module TestModule')
    end
    it 'prints change when ast inside empty module' do
      ast_content = <<-eos
module TestModule

end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 2)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=nil
      subject.new_lineno=2
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('created module TestModule')
    end
  end
end