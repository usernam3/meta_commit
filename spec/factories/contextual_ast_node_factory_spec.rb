require 'rspec'

describe MetaCommit::Factories::ContextualAstNodeFactory do
  describe '#create_ast_path' do
    it 'returns empty ast path when empty ast passed' do
      source_ast = double(:source_ast, {:children => [], :first_line => 0, :last_line => 0})

      ast_path = subject.create_ast_path(source_ast, 2)

      expect(ast_path).to be_a(MetaCommit::Models::ContextualAstNode)
      expect(ast_path.target_node).to be nil
      expect(ast_path.context_nodes).to be_empty
    end
    it 'returns nil when ast not found' do
      source_ast = double(:source_ast, {
          :first_line => 0,
          :last_line => 2,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1}),
              double(:child2, {:first_line => 1, :last_line => 2})
          ]
      })

      ast_path = subject.create_ast_path(source_ast, 3)

      expect(ast_path.target_node).to be nil
      expect(ast_path.context_nodes).to be_empty
    end
    it 'returns lowest level ast on line' do
      deepest_child = double(:deepest_child, {:first_line => 1, :last_line => 2, :children => []})
      source_ast = double(:source_ast, {
          :first_line => 0,
          :last_line => 2,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1, :children => []}),
              double(:child2, {:first_line => 1, :last_line => 2, :children => [deepest_child]}),
              double(:child3, {:first_line => 2, :last_line => 3, :children => []})
          ]
      })

      ast_path = subject.create_ast_path(source_ast, 1)

      expect(ast_path.target_node).to eq(deepest_child)
    end
    it 'adds every level of passed ast to context' do
      source_ast = double(:source_ast, {
          :first_line => 0,
          :last_line => 5,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1, :children => []}),
              double(:child2, {:first_line => 1, :last_line => 2, :children => []}),
              double(:child3, {:first_line => 2, :last_line => 5, :children => [
                  double(:child31, {:first_line => 2, :last_line => 4, :children => [
                      double(:child311, {:first_line => 3, :last_line => 3, :children => []})
                  ]}),
                  double(:child32, {:first_line => 4, :last_line => 5, :children => []})
              ]})
          ]
      })

      ast_path = subject.create_ast_path(source_ast, 3)

      expect(ast_path.context_nodes).to eq([
                                               source_ast,
                                               source_ast.children.last,
                                               source_ast.children.last.children.first,
                                               source_ast.children.last.children.first.children.last,
                                           ])
    end
  end
end