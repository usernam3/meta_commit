module MetaCommit::Models
  # Stores specific node from ast and all nodes bypassed on the way to target node
  # @attr [Parser::AST::Node] target_node Target node from AST
  # @attr [Array<Parser::AST::Node>] context_nodes Nodes bypassed on the way to target node
  class ContextualAstNode
    attr_accessor :target_node, :context_nodes

    def is_module_definition?(node)
      node.type == :module
    end

    def is_class_definition?(node)
      node.type == :class
    end

    def is_method_definition?(node)
      node.type == :def
    end

    def extract_module_name(node)
      node.children.first.children.last.to_s
    end

    def extract_class_name(node)
      node.children.first.children.last.to_s
    end

    def extract_method_name(node)
      node.children.first.to_s
    end

    def empty_ast?
      @target_node.nil?
    end

    def is_module?
      @target_node.type == :module
    end

    def is_class?
      @target_node.type == :class
    end

    def is_method?
      @target_node.type == :def
    end

    # on created class only first line goes to diff
    def is_name_of_class?
      (@target_node.type == :const) and (@context_nodes.length > 1) and (@context_nodes[@context_nodes.length - 1 - 1].type == :class)
    end

    # on created module only first line goes to diff
    def is_name_of_module?
      (@target_node.type == :const) and (@context_nodes.length > 1) and (@context_nodes[@context_nodes.length - 1 - 1].type == :module)
    end

    def module_name
      @target_node.children.first.children.last.to_s
    end

    def class_name
      @target_node.children.first.children.last.to_s
    end

    def method_name
      @target_node.children.first.to_s
    end

    def name_of_context_module
      @context_nodes.reverse.each do |parent|
        return extract_module_name(parent) if is_module_definition?(parent)
      end
    end

    def name_of_context_class
      @context_nodes.reverse.each do |parent|
        return extract_class_name(parent) if is_class_definition?(parent)
      end
    end

    def name_of_context_method
      @context_nodes.reverse.each do |parent|
        return extract_method_name(parent) if is_method_definition?(parent)
      end
    end

    def is_in_context_of_module?
      @context_nodes.each do |parent|
        return true if is_module_definition?(parent)
      end
      false
    end

    def is_in_context_of_class?
      @context_nodes.each do |parent|
        return true if is_class_definition?(parent)
      end
      false
    end

    def is_in_context_of_method?
      @context_nodes.each do |parent|
        return true if is_method_definition?(parent)
      end
      false
    end

    # @param [Integer] depth
    # @return [String]
    def path_to_component(depth=nil)
      depth = -1 if depth.nil?
      result = []
      result.concat([name_of_context_module, is_in_context_of_class? && depth < 1 ? '::' : '']) if is_in_context_of_module? && depth < 2
      result.concat([name_of_context_class]) if is_in_context_of_class? && depth < 1
      result.concat(['#', name_of_context_method]) if is_in_context_of_method? && depth < 0
      result .join('')
    end
  end
end