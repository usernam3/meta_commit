module MetaCommit::Plugin::Ruby::Diffs
  class ModuleCreation < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_ADDITION && !new_ast_path.empty_ast? && (new_ast_path.is_module? || new_ast_path.is_name_of_module?)
    end

    def string_representation
      if @new_ast_path.is_module?
        return "created module #{new_ast_path.module_name}"
      end
      "created module #{new_ast_path.name_of_context_module}"
    end
  end
end