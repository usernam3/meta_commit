module MetaCommit::Extension::RubySupport::Diffs
  class Deletion < Diff
    def string_representation
      action = 'removed'
      if @old_ast_path.ast.is_module?
        return "#{action} module #{old_ast_path.ast.module_name}"
      end
      if @old_ast_path.ast.is_name_of_module?
        return "#{action} module #{old_ast_path.ast.name_of_context_module}"
      end
      if @old_ast_path.ast.is_class?
        if @_ast_path.is_in_context_of_module?
          return "#{action} #{name_of_context_module}::#{new_ast_path.ast.class_name}"
        end
        return "#{action} class #{old_ast_path.ast.class_name}"
      end
      if @old_ast_path.ast.is_name_of_class?
        return "#{action} class #{old_ast_path.ast.name_of_context_class}"
      end
      if @old_ast_path.ast.is_method?
        if @old_ast_path.ast.is_in_context_of_class?
          return "#{action} #{old_ast_path.ast.name_of_context_class}##{old_ast_path.ast.method_name}"
        end
        if @old_ast_path.ast.is_in_context_of_module?
          if @old_ast_path.ast.is_in_context_of_class?
            return "#{action} #{old_ast_path.ast.name_of_context_module}::#{old_ast_path.ast.name_of_context_class}##{old_ast_path.ast.method_name}"
          end
          return "#{action} method #{old_ast_path.ast.method_name} from module #{old_ast_path.ast.name_of_context_module}"
        end
      end
      if @old_ast_path.ast.is_in_context_of_method?
        return "changes in method #{@old_ast_path.ast.ast.name_of_context_method}"
      end
      'deletion was performed'
    end
  end
end