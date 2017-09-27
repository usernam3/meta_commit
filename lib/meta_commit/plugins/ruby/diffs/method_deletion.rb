module MetaCommit::Plugin::Ruby::Diffs
  class MethodDeletion < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_DELETION && !old_ast_path.target_node.empty_ast? && (old_ast_path.target_node.is_method? || is_in_context_of_method?(old_ast_path))
    end

    def string_representation
      if @old_ast_path.target_node.is_method?
        if is_in_context_of_module?(@old_ast_path)
          if is_in_context_of_class?(@old_ast_path)
            return "removed #{name_of_context_module(old_ast_path)}::#{name_of_context_class(old_ast_path)}##{old_ast_path.target_node.method_name}"
          end
          return "removed method #{old_ast_path.target_node.method_name} from module #{name_of_context_module(old_ast_path)}"
        end
        if is_in_context_of_class?(@old_ast_path)
          return "removed #{name_of_context_class(old_ast_path)}##{old_ast_path.target_node.method_name}"
        end
      end
      "changes in method #{name_of_context_method(old_ast_path)}"
    end
  end
end