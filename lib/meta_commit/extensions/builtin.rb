require 'meta_commit_contracts'

module MetaCommit::Extension::Builtin
  class Locator < MetaCommit::Contracts::Locator
    def parsers
      [Parser]
    end

    def diffs
      [Diff]
    end
  end

  class Ast < MetaCommit::Contracts::Ast
    attr_reader :first_line, :last_line, :lines

    def initialize(first_lineno, last_lineno, lines)
      @first_line =first_lineno
      @last_line = last_lineno
      @lines = lines
    end

    def children
      return [Ast.new(@first_line, @last_line, [])] if @lines.empty?
      [Ast.new(@first_line+1, @last_line, @lines)]
    end
  end

  class Parser < MetaCommit::Contracts::Parser
    def self.supported_file_extensions
      %w(txt md rb)
    end

    # @return [Boolean]
    def self.supports_syntax?(source_code)
      true
    end

    def parse(source_code)
      lines = source_code.split("\n")
      Ast.new(0, lines.length-1, lines)
    end
  end

  class Diff < MetaCommit::Contracts::Diff
    attr_writer :diff_type, :commit_old, :commit_new, :old_file, :new_file, :old_lineno, :new_lineno, :old_ast_path, :new_ast_path

    def string_representation
      "#{@diff_type} | in files #{@old_file}:#{@old_lineno} #{@new_file}:#{@new_lineno} | between commits #{@commit_old} and #{@commit_new}"
    end

    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      true
    end

    def supports_parser?(parser)
      true
    end

    def to_s
      string_representation
    end
  end
end