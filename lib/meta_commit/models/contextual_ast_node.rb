module MetaCommit::Models
  # Stores specific node from ast and all nodes bypassed on the way to target node
  # @attr [MetaCommit::Contracts::Ast] target_node Target node from AST
  # @attr [Array<MetaCommit::Contracts::Ast>] context_nodes Nodes bypassed on the way to target node
  class ContextualAstNode
    attr_accessor :target_node, :context_nodes
  end
end