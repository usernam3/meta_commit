module MetaCommit::Models::Diffs
  class Replacement < Diff
    def string_representation
      if @old_ast_path.is_name_of_module? && @new_ast_path.is_name_of_module?
        return "renamed module #{old_ast_path.name_of_context_module} to #{new_ast_path.name_of_context_module}"
      end
      if @old_ast_path.is_name_of_class? && @new_ast_path.is_name_of_class?
        return "renamed class #{old_ast_path.name_of_context_class} to #{new_ast_path.name_of_context_class}"
      end
      if @old_ast_path.is_in_context_of_method? && @new_ast_path.is_in_context_of_method?
        if @new_ast_path.is_in_context_of_class?
          return "changes in #{new_ast_path.name_of_context_class}##{new_ast_path.name_of_context_method}"
        end
        return "changes in ##{new_ast_path.name_of_context_method}"
      end
      'replacing was performed'
    end
  end
end