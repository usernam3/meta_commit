module MetaCommit::Models::Diffs
  class MethodCreation < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Models::Diffs::Diff::TYPE_ADDITION && !new_ast_path.empty_ast? && (new_ast_path.is_method? || new_ast_path.is_in_context_of_method?)
    end

    def string_representation
      if @new_ast_path.is_method?
        if @new_ast_path.is_in_context_of_module?
          if @new_ast_path.is_in_context_of_class?
            return "created #{new_ast_path.name_of_context_module}::#{new_ast_path.name_of_context_class}##{new_ast_path.method_name}"
          end
          return "created #{new_ast_path.name_of_context_module}##{new_ast_path.method_name}"
        end
        if @new_ast_path.is_in_context_of_class?
          return "created #{new_ast_path.name_of_context_class}##{new_ast_path.method_name}"
        end
      end
      "changes in method #{new_ast_path.name_of_context_method}"
    end
  end
end