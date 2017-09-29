require "meta_commit/plugins/contracts/diff"

module MetaCommit::Plugin::Ruby::Diffs
  # Base class for diffs
  # @attr [Symbol] diff_type
  # @attr [String] commit_old
  # @attr [String] commit_new
  # @attr [String] old_file
  # @attr [String] new_file
  # @attr [String] old_lineno
  # @attr [String] new_lineno
  # @attr [MetaCommit::Models::ContextualAstNode] old_ast_path
  # @attr [MetaCommit::Models::ContextualAstNode] new_ast_path
  class Diff < MetaCommit::Contracts::Diff

    TYPE_ADDITION = :addition
    TYPE_DELETION = :deletion
    TYPE_REPLACE = :replace
    SUPPORTED_PARSERS = [MetaCommit::Plugin::Ruby::Parsers::Ruby]

    attr_accessor :diff_type
    attr_accessor :commit_old, :commit_new
    attr_accessor :old_file, :new_file
    attr_accessor :old_lineno, :new_lineno
    attr_accessor :old_ast_path, :new_ast_path

    # @param [Class] parser
    # @return [Boolean]
    def supports_parser?(parser)
      SUPPORTED_PARSERS.include?(parser)
    end

    # @param [Symbol] type
    # @param [String] old_file_name
    # @param [String] new_file_name
    # @param [String] old_ast_path
    # @param [String] new_ast_path
    # @return [Boolean]
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      true
    end

    # @return [String]
    def inspect
      string_representation
    end

    # @return [String]
    def to_s
      string_representation
    end

    # @return [String]
    def string_representation
      "#{diff_type} was performed"
    end

    # @return [Boolean]
    def type_addition?
      @diff_type == TYPE_ADDITION
    end

    # @return [Boolean]
    def type_deletion?
      @diff_type == TYPE_DELETION
    end

    # @return [Boolean]
    def type_replace?
      @diff_type == TYPE_REPLACE
    end


    # @param [Object] ast
    # @param [Integer] depth
    # @return [String]
    def path_to_component(ast, depth=nil)
      depth = -1 if depth.nil?
      result = []
      result.concat([name_of_context_module(ast), is_in_context_of_class?(ast) && depth < 1 ? '::' : '']) if is_in_context_of_module?(ast) && depth < 2
      result.concat([name_of_context_class(ast)]) if is_in_context_of_class?(ast) && depth < 1
      result.concat(['#', name_of_context_method(ast)]) if is_in_context_of_method?(ast) && depth < 0
      result.join('')
    end

    # on created class only first line goes to diff
    # @param [MetaCommit::Model::ContextualAstNode] ast
    def is_name_of_class?(ast)
      (ast.target_node.ast.type == :const) and (ast.context_nodes.length > 1) and (ast.context_nodes[ast.context_nodes.length - 1 - 1].ast.type == :class)
    end

    # on created module only first line goes to diff
    # @param [MetaCommit::Model::ContextualAstNode] ast
    def is_name_of_module?(ast)
      (ast.target_node.ast.type == :const) and (ast.context_nodes.length > 1) and (ast.context_nodes[ast.context_nodes.length - 1 - 1].ast.type == :module)
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    def name_of_context_module(ast)
      ast.context_nodes.reverse.each do |parent|
        return parent.module_name if parent.is_module?
      end
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    def name_of_context_class(ast)
      ast.context_nodes.reverse.each do |parent|
        return parent.class_name if parent.is_class?
      end
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    def name_of_context_method(ast)
      ast.context_nodes.reverse.each do |parent|
        return parent.method_name if parent.is_method?
      end
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    # @return [Boolean]
    def is_in_context_of_module?(ast)
      ast.context_nodes.each do |parent|
        return true if parent.is_module?
      end
      false
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    # @return [Boolean]
    def is_in_context_of_class?(ast)
      ast.context_nodes.each do |parent|
        return true if parent.is_class?
      end
      false
    end

    # @param [MetaCommit::Model::ContextualAstNode] ast
    # @return [Boolean]
    def is_in_context_of_method?(ast)
      ast.context_nodes.each do |parent|
        return true if parent.is_method?
      end
      false
    end
  end
end