require 'rspec'

describe MetaCommit::Plugin::Ruby::Diffs::ChangesInMethod do
  let(:type) { MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_REPLACE }
  let(:old_file_name) { 'old_file_name' }
  let(:new_file_name) { 'new_file_name' }

  describe '#supports_change' do
    it 'supports replace where both ast are in context of method' do
      old_ast_content = <<-eos
module TestModule
  class TestClass
    def test_method

    end
  end
end
      eos
      old_source_ast = Parser::CurrentRuby.parse(old_ast_content)
      old_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(old_source_ast, 4)

      new_ast_content = <<-eos
module TestModule
  class TestClass
    def test_method




    end
  end
end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(new_source_ast, 6)
      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
  end

  describe '#string_representation' do
    it 'prints change when new ast is in context of class' do
      old_ast_path = nil

      new_ast_content = <<-eos
module TestModule
  class TestClassNEW
    def test_method


    end
  end
end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(new_source_ast, 5)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=5
      subject.new_lineno=5
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('changes in TestClassNEW#test_method')
    end
    it 'prints change when when changes in method' do
      old_ast_path = nil

      new_ast_content = <<-eos
    def test_method


    end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Factories::ContextualAstNodeFactory.new.create_ast_path(new_source_ast, 3)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=5
      subject.new_lineno=5
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('changes in #test_method')
    end
  end
end