require 'rspec'

describe MetaCommit::Plugin::Ruby::Diffs::MethodCreation do
  let(:type) { MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_ADDITION }
  let(:old_file_name) { 'old_file_name' }
  let(:new_file_name) { 'new_file_name' }
  let(:old_ast_path) { nil }

  describe '#supports_change' do
    it 'supports addition where ast is method definition' do
      ast_content = <<-eos
module TestModule
  class TestClass
    def test_method
    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 3)
      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
    it 'supports addition where ast is in context of method' do
      ast_content = <<-eos
module TestModule
  class TestClass
    def test_method

    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 4)

      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
  end

  describe '#string_representation' do
    it 'prints change when is method in context of module and class' do
      ast_content = <<-eos
module TestModule
  class TestClass
    def test_method

    end
  end
end
      eos
      source_ast = Parser::CurrentRuby.parse(ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(source_ast, 3)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=nil
      subject.new_lineno=2
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('created TestModule::TestClass#test_method')
    end
    it 'prints change when is method in context of module' do
      ast_content = <<-eos
module TestModule
    def test_method

    end
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

      expect(subject.string_representation).to eq('created TestModule#test_method')
    end
    it 'prints change when is method in context of class' do
      ast_content = <<-eos
class TestModule
    def test_method

    end
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

      expect(subject.string_representation).to eq('created TestModule#test_method')
    end
  end
end