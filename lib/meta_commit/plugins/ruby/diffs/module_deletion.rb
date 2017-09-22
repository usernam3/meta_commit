module MetaCommit::Plugin::Ruby::Diffs
  class ModuleDeletion < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_DELETION && !old_ast_path.empty_ast? && (old_ast_path.is_module? || old_ast_path.is_name_of_module?)
    end

    def string_representation
      if @old_ast_path.is_module?
        return "removed module #{old_ast_path.module_name}"
      end
      "removed module #{old_ast_path.name_of_context_module}"
    end
  end
end