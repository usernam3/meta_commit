module MetaCommit::Plugin::Ruby::Diffs
  class ClassCreation < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_ADDITION && !new_ast_path.empty_ast? && (new_ast_path.is_class? || new_ast_path.is_name_of_class?)
    end

    def string_representation
      if @new_ast_path.is_class?
        if @new_ast_path.is_in_context_of_module?
          return "created #{new_ast_path.name_of_context_module}::#{new_ast_path.class_name}"
        end
        return "created class #{new_ast_path.class_name}"
      end
      if @new_ast_path.is_in_context_of_module?
        return "created #{new_ast_path.name_of_context_module}::#{new_ast_path.name_of_context_class}"
      end
      "created class #{new_ast_path.name_of_context_class}"
    end
  end
end