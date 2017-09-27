module MetaCommit::Plugin::Ruby::Diffs
  class ClassCreation < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_ADDITION && !new_ast_path.target_node.empty_ast? && (new_ast_path.target_node.is_class? || is_name_of_class?(new_ast_path))
    end

    def string_representation
      if @new_ast_path.target_node.is_class?
        if is_in_context_of_module?(@new_ast_path)
          return "created #{name_of_context_module(new_ast_path)}::#{new_ast_path.target_node.class_name}"
        end
        return "created class #{new_ast_path.class_name}"
      end
      if is_in_context_of_module?(@new_ast_path)
        return "created #{name_of_context_module(new_ast_path)}::#{name_of_context_class(new_ast_path)}"
      end
      "created class #{name_of_context_class(new_ast_path)}"
    end
  end
end