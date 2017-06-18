module MetaCommit::Models::Diffs
  class ModuleRename < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Models::Diffs::Diff::TYPE_REPLACE && !old_ast_path.empty_ast? && !new_ast_path.empty_ast? && old_ast_path.is_name_of_module? && new_ast_path.is_name_of_module?
    end

    def string_representation
      "renamed module #{old_ast_path.name_of_context_module} to #{new_ast_path.name_of_context_module}"
    end
  end
end