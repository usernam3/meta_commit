module MetaCommit::Models::Diffs
  class MethodDeletion < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Models::Diffs::Diff::TYPE_DELETION && !old_ast_path.empty_ast? && (old_ast_path.is_method? || old_ast_path.is_in_context_of_method?)
    end

    def string_representation
      if @old_ast_path.is_method?
        if @old_ast_path.is_in_context_of_module?
          if @old_ast_path.is_in_context_of_class?
            return "removed #{old_ast_path.name_of_context_module}::#{old_ast_path.name_of_context_class}##{old_ast_path.method_name}"
          end
          return "removed method #{old_ast_path.method_name} from module #{old_ast_path.name_of_context_module}"
        end
        if @old_ast_path.is_in_context_of_class?
          return "removed #{old_ast_path.name_of_context_class}##{old_ast_path.method_name}"
        end
      end
      "changes in method #{old_ast_path.name_of_context_method}"
    end
  end
end