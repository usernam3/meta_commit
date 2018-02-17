module MetaCommit::Factories
  # Factory that builds ContextualAstNode from ast nodes
  class ContextualAstNodeFactory
    WHOLE_FILE = :whole_file_change

    # @param [MetaCommit::Contracts::Ast] source_ast
    # @param [Integer] line_number
    # @param [Integer] column_number
    # @return [MetaCommit::Models::ContextualAstNode]
    def create_contextual_node(source_ast, line_number, column_number)
      visited_nodes = []
      contextual_node = MetaCommit::Models::ContextualAstNode.new
      contextual_node.parser_class = source_ast.parser_class
      contextual_node.target_node = collect_path_to_ast_at_line(source_ast, line_number, column_number, visited_nodes)
      contextual_node.context_nodes = visited_nodes
      contextual_node.whole_file_change = (line_number == WHOLE_FILE)
      contextual_node
    end

    # @param [MetaCommit::Contracts::Ast] ast
    # @param [Integer] lineno
    # @param [Integer] column_number
    # @param [Array<MetaCommit::Contracts::Ast>] accumulator
    # @return [MetaCommit::Contracts::Ast]
    def collect_path_to_ast_at_line(ast, lineno, column_number, accumulator)
      return ast if lineno == WHOLE_FILE
      return nil if ast.nil? || (lines?(ast) && !covers_line?(ast, lineno))
      return nil if exact_line?(ast, lineno) && !column_number.nil? && columns?(ast) && !covers_column?(ast, column_number)

      closest_ast = ast
      accumulator.push(closest_ast)
      ast.children.each do |child|
        found_ast = collect_path_to_ast_at_line(child, lineno, column_number, accumulator)
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


    # @param [MetaCommit::Contracts::Ast] ast
    # @param [Integer] line
    # @return [Boolean]
    def exact_line?(ast, line)
      (ast.first_line == line) && (ast.last_line == line)
    end

    protected :exact_line?


    # @param [MetaCommit::Contracts::Ast] ast
    # @return [Boolean]
    def columns?(ast)
      !(ast.first_column.nil? || ast.last_column.nil?)
    end

    protected :columns?


    # @param [MetaCommit::Contracts::Ast] ast
    # @param [Integer] column
    # @return [Boolean]
    def covers_column?(ast, column)
      (ast.first_column <= column) && (ast.last_column >= column)
    end

    protected :covers_column?
  end
end