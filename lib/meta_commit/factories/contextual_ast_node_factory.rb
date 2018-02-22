module MetaCommit::Factories
  # Factory that builds ContextualAstNode from ast nodes
  class ContextualAstNodeFactory
    WHOLE_FILE = :whole_file_change

    # @param [MetaCommit::Contracts::Ast] source_ast
    # @param [Integer] line_number
    # @return [MetaCommit::Models::ContextualAstNode]
    def create_contextual_node(source_ast, line_number)
      visited_nodes = []
      contextual_node = MetaCommit::Models::ContextualAstNode.new
      contextual_node.parser_class = source_ast.parser_class
      contextual_node.target_node = collect_path_to_ast_at_line(source_ast, line_number, visited_nodes)
      contextual_node.context_nodes = visited_nodes
      contextual_node.whole_file_change = (line_number == WHOLE_FILE)
      contextual_node
    end

    # @param [MetaCommit::Contracts::Ast] ast
    # @param [Integer] lineno
    # @param [Array<MetaCommit::Contracts::Ast>] accumulator
    # @return [MetaCommit::Contracts::Ast]
    def collect_path_to_ast_at_line(ast, lineno, accumulator)
      return ast if lineno == WHOLE_FILE
      return nil if ast.nil? || (lines?(ast) && !covers_line?(ast, lineno))

      closest_ast = ast
      accumulator.push(closest_ast)
      ast.children.each do |child|
        found_ast = collect_path_to_ast_at_line(child, lineno, accumulator)
        closest_ast = found_ast unless found_ast.nil?
      end
      closest_ast
    end

    protected :collect_path_to_ast_at_line


    # @param [MetaCommit::Contracts::Ast] ast
    # @return [Boolean]
    def lines?(ast)
      !(ast.first_line.nil? && ast.last_line.nil?)
    end

    protected :lines?


    # @param [MetaCommit::Contracts::Ast] ast
    # @param [Integer] line
    # @return [Boolean]
    def covers_line?(ast, line)
      (ast.first_line <= line) && (ast.last_line >= line)
    end

    protected :covers_line?

  end
end