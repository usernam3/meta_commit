module MetaCommit::Plugin::Ruby::Diffs
  class ChangesInMethod < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_REPLACE && !old_ast_path.empty_ast? && !new_ast_path.empty_ast? && old_ast_path.is_in_context_of_method? && new_ast_path.is_in_context_of_method?
    end

    def string_representation
      if @new_ast_path.is_in_context_of_class?
        return "changes in #{new_ast_path.name_of_context_class}##{new_ast_path.name_of_context_method}"
      end
      "changes in ##{new_ast_path.name_of_context_method}"
    end
  end
end