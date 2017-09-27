require "meta_commit/plugins/contracts/ast"
require 'byebug'

module MetaCommit::Plugin::Ruby::Models
  # Adapter which implements MetaCommit::Contracts::Ast contract and wraps Parser::AST::Node
  # @attr [Array<Parser::AST::Node>] ast
  class Ast < MetaCommit::Contracts::Ast
    attr_reader :ast

    # @param [Parser::AST::Node] ast
    def initialize(ast)
      @ast = ast
    end

    # @return [Array<MetaCommit::Contracts::Ast>]
    def children
      @ast.children
          .map {|child| Ast.new(child)}
    end

    # @return [Integer]
    def first_line
      return unless @ast.respond_to?(:location)
      return if @ast.location.class == Parser::Source::Map::Collection
      @ast.location.first_line
    end

    # @return [Integer]
    def last_line
      return unless @ast.respond_to?(:location)
      return if @ast.location.class == Parser::Source::Map::Collection
      @ast.location.last_line
    end

    # @return [Boolean]
    def empty_ast?
      @ast.nil?
    end

    # @return [Boolean]
    def is_module?
      @ast.type == :module
    end

    # @return [Boolean]
    def is_class?
      @ast.type == :class
    end

    # @return [Boolean]
    def is_method?
      @ast.type == :def
    end

    # @return [String]
    def module_name
      @ast.children.first.children.last.to_s
    end

    # @return [String]
    def class_name
      @ast.children.first.children.last.to_s
    end

    # @return [String]
    def method_name
      @ast.children.first.to_s
    end

  end
end