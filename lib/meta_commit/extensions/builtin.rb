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
    def string_representation
      prefix = 'all file ' if change_context.new_contextual_ast.whole_file_change
      column = " (C#{change_context.column})" unless change_context.column.nil?

      "#{prefix}#{change_context.type} | in files #{change_context.old_file_path}:#{change_context.old_lineno} #{change_context.new_file_path}:#{change_context.new_lineno}#{column} | between commits #{change_context.commit_id_old} and #{change_context.commit_id_new}"
    end

    def supports_change(context)
      true
    end

    def supports_parser?(parser)
      [Parser].include?(parser)
    end

    def to_s
      string_representation
    end

    # @return [Boolean]
    def type_addition?
      change_context.type == MetaCommit::Contracts::Diff::TYPE_ADDITION
    end

    # @return [Boolean]
    def type_deletion?
      change_context.type == MetaCommit::Contracts::Diff::TYPE_DELETION
    end

    # @return [Boolean]
    def type_replace?
      change_context.type == MetaCommit::Contracts::Diff::TYPE_REPLACE
    end
  end
end