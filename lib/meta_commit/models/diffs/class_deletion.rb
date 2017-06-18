module MetaCommit::Models::Diffs
  class ClassDeletion < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Models::Diffs::Diff::TYPE_DELETION && !old_ast_path.empty_ast? && (old_ast_path.is_class? || old_ast_path.is_name_of_class?)
    end

    def string_representation
      if @old_ast_path.is_class?
        if @old_ast_path.is_in_context_of_module?
          return "removed class #{old_ast_path.class_name} from module #{old_ast_path.name_of_context_module}"
        end
      end
      "removed class #{old_ast_path.name_of_context_class}"
    end
  end
end