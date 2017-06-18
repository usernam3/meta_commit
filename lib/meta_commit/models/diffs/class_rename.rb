module MetaCommit::Models::Diffs
  class ClassRename < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Models::Diffs::Diff::TYPE_REPLACE && !old_ast_path.nil? && !new_ast_path.nil? && old_ast_path.is_name_of_class? && new_ast_path.is_name_of_class?
    end

    def string_representation
      "renamed class #{old_ast_path.name_of_context_class} to #{new_ast_path.name_of_context_class}"
    end
  end
end