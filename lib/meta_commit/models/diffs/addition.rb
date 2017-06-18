module MetaCommit::Models::Diffs
  class Addition < Diff
    def string_representation
      action = 'created'
      if @new_ast_path.is_class?
        if @new_ast_path.is_in_context_of_module?
          return "#{action} #{new_ast_path.name_of_context_module}::#{new_ast_path.class_name}"
        end
        return "#{action} class #{new_ast_path.class_name}"
      end
      if @new_ast_path.is_name_of_class?
        if @new_ast_path.is_in_context_of_module?
          return "#{action} #{new_ast_path.name_of_context_module}::#{new_ast_path.name_of_context_class}"
        end
        return "#{action} class #{new_ast_path.name_of_context_class}"
      end
      if @new_ast_path.is_method?
        if @new_ast_path.is_in_context_of_class?
          return "#{action} #{new_ast_path.name_of_context_class}##{new_ast_path.method_name}"
        end
        if @new_ast_path.is_in_context_of_module?
          if @new_ast_path.is_in_context_of_class?
            return "#{action} #{new_ast_path.name_of_context_module}::#{new_ast_path.name_of_context_class}##{new_ast_path.method_name}"
          end
          return "#{action} #{new_ast_path.name_of_context_module}##{new_ast_path.method_name}"
        end
      end
      if @new_ast_path.is_in_context_of_method?
        return "changes in method #{@new_ast_path.name_of_context_method}"
      end
      'addition was performed'
    end
  end
end