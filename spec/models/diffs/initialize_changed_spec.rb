require 'rspec'
require 'spec_helper'
require 'byebug'

describe MetaCommit::Models::Diffs::InitializeChanged do
  let(:type) { MetaCommit::Models::Diffs::Diff::TYPE_REPLACE }
  let(:old_file_name) { 'old_file_name' }
  let(:new_file_name) { 'new_file_name' }

  describe '#supports_change' do
    it 'supports replace where both ast are #initialize method signature changes' do
      old_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize

    end
  end
end
      eos
      old_source_ast = Parser::CurrentRuby.parse(old_ast_content)
      old_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(old_source_ast, 3)

      new_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize(param1)

    end
  end
end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(new_source_ast, 3)

      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
    it 'supports replace where ast are changes inside #initialize method' do
      old_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize
      a = 1 + 1
    end
  end
end
      eos
      old_source_ast = Parser::CurrentRuby.parse(old_ast_content)
      old_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(old_source_ast, 4)

      new_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize(param1)

    end
  end
end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(new_source_ast, 3)

      expect(subject.supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)).to be true
    end
  end

  describe '#string_representation' do
    it 'prints change' do
      old_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize
      a = 1 + 1
    end
  end
end
      eos
      old_source_ast = Parser::CurrentRuby.parse(old_ast_content)
      old_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(old_source_ast, 4)

      new_ast_content = <<-eos
module TestModule
  class TestClass
    def initialize(param1)

    end
  end
end
      eos
      new_source_ast = Parser::CurrentRuby.parse(new_ast_content)
      new_ast_path = MetaCommit::Models::Factories::AstPathFactory.new.create_ast_path(new_source_ast, 3)

      subject.diff_type=type
      subject.commit_old=nil
      subject.commit_new=nil
      subject.old_file=old_file_name
      subject.new_file=new_file_name
      subject.old_lineno=4
      subject.new_lineno=3
      subject.old_ast_path=old_ast_path
      subject.new_ast_path=new_ast_path

      expect(subject.string_representation).to eq('changes in initialization of TestModule::TestClass')
    end
  end
end