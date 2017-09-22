module MetaCommit::Plugin::Ruby::Diffs
  class Deletion < Diff
    def string_representation
      action = 'removed'
      if @old_ast_path.is_module?
        return "#{action} module #{old_ast_path.module_name}"
      end
      if @old_ast_path.is_name_of_module?
        return "#{action} module #{old_ast_path.name_of_context_module}"
      end
      if @old_ast_path.is_class?
        if @_ast_path.is_in_context_of_module?
          return "#{action} #{name_of_context_module}::#{new_ast_path.class_name}"
        end
        return "#{action} class #{old_ast_path.class_name}"
      end
      if @old_ast_path.is_name_of_class?
        return "#{action} class #{old_ast_path.name_of_context_class}"
      end
      if @old_ast_path.is_method?
        if @old_ast_path.is_in_context_of_class?
          return "#{action} #{old_ast_path.name_of_context_class}##{old_ast_path.method_name}"
        end
        if @old_ast_path.is_in_context_of_module?
          if @old_ast_path.is_in_context_of_class?
            return "#{action} #{old_ast_path.name_of_context_module}::#{old_ast_path.name_of_context_class}##{old_ast_path.method_name}"
          end
          return "#{action} method #{old_ast_path.method_name} from module #{old_ast_path.name_of_context_module}"
        end
      end
      if @old_ast_path.is_in_context_of_method?
        return "changes in method #{@old_ast_path.name_of_context_method}"
      end
      'deletion was performed'
    end
  end
end