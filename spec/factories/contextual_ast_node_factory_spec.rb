require 'spec_helper'

describe MetaCommit::Factories::ContextualAstNodeFactory do
  describe '#create_ast_path' do
    it 'returns empty ast path when empty ast passed' do
      source_ast = double(:source_ast, {:parser_class => Class, :children => [], :first_line => 0, :last_line => 0, :first_column => nil, :last_column => nil})

      ast_path = subject.create_contextual_node(source_ast, 2)

      expect(ast_path).to be_a(MetaCommit::Models::ContextualAstNode)
      expect(ast_path.target_node).to be nil
      expect(ast_path.context_nodes).to be_empty
    end

    it 'returns nil when ast not found' do
      source_ast = double(:source_ast, {
          :parser_class => Class,
          :first_line => 0,
          :last_line => 2,
          :first_column => nil,
          :last_column => nil,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1, :first_column => nil, :last_column => nil,}),
              double(:child2, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil,})
          ]
      })

      ast_path = subject.create_contextual_node(source_ast, 3)

      expect(ast_path.target_node).to be nil
      expect(ast_path.context_nodes).to be_empty
    end

    it 'returns lowest level ast on line' do
      deepest_child = double(:deepest_child, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => []})
      source_ast = double(:source_ast, {
          :parser_class => Class,
          :first_line => 0,
          :last_line => 2,
          :first_column => nil,
          :last_column => nil,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1, :first_column => nil, :last_column => nil, :children => []}),
              double(:child2, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => [deepest_child]}),
              double(:child3, {:first_line => 2, :last_line => 3, :first_column => nil, :last_column => nil, :children => []})
          ]
      })

      ast_path = subject.create_contextual_node(source_ast, 1)

      expect(ast_path.target_node).to eq(deepest_child)
    end

    it 'adds every level of passed ast to context' do
      source_ast = double(:source_ast, {
          :parser_class => Class,
          :first_line => 0,
          :last_line => 5,
          :first_column => nil,
          :last_column => nil,
          :children => [
              double(:child1, {:first_line => 0, :last_line => 1, :first_column => nil, :last_column => nil, :children => []}),
              double(:child2, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => []}),
              double(:child3, {:first_line => 2, :last_line => 5, :first_column => nil, :last_column => nil, :children => [
                  double(:child31, {:first_line => 2, :last_line => 4, :first_column => nil, :last_column => nil, :children => [
                      double(:child311, {:first_line => 3, :last_line => 3, :first_column => nil, :last_column => nil, :children => []})
                  ]}),
                  double(:child32, {:first_line => 4, :last_line => 5, :first_column => nil, :last_column => nil, :children => []})
              ]})
          ]
      })

      ast_path = subject.create_contextual_node(source_ast, 3)

      expect(ast_path.context_nodes).to eq([
                                               source_ast,
                                               source_ast.children.last,
                                               source_ast.children.last.children.first,
                                               source_ast.children.last.children.first.children.last,
                                           ])
    end

    it 'assigns parser class from passed ast' do
      deepest_child = double(:deepest_child, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => []})
      source_ast = double(:source_ast, {
          :parser_class => :parser_class,
          :first_line => 0,
          :last_line => 2,
          :first_column => nil,
          :last_column => nil,
          :children => [
              double(:child1, {:parser_class => :parser_class1,:first_line => 0, :last_line => 1, :first_column => nil, :last_column => nil, :children => []}),
              double(:child2, {:parser_class => :parser_class2,:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => [deepest_child]}),
              double(:child3, {:parser_class => :parser_class3,:first_line => 2, :last_line => 3, :first_column => nil, :last_column => nil, :children => []})
          ]
      })

      ast_path = subject.create_contextual_node(source_ast, 1)

      expect(ast_path.parser_class).to eq(:parser_class)
    end

    it 'returns passed ast as target node when whole file changed' do
      source_ast = double(:source_ast, {
          :parser_class => :parser_class,
          :first_line => 0,
          :last_line => 2,
          :first_column => nil,
          :last_column => nil,
          :children => [
              double(:child1, {:parser_class => :parser_class1, :first_line => 0, :last_line => 1, :first_column => nil, :last_column => nil, :children => []}),
              double(:child2, {:parser_class => :parser_class2, :first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => [
                  double(:deepest_child, {:first_line => 1, :last_line => 2, :first_column => nil, :last_column => nil, :children => []}),
              ]}),
              double(:child3, {:parser_class => :parser_class3, :first_line => 2, :last_line => 3, :first_column => nil, :last_column => nil, :children => []})
          ]
      })

      ast_path = subject.create_contextual_node(source_ast, MetaCommit::Factories::ContextualAstNodeFactory::WHOLE_FILE)

      expect(ast_path.target_node).to eq(source_ast)
      expect(ast_path.context_nodes).to eq([])
    end
  end
end