module MetaCommit::Plugin::Ruby::Diffs
  class ClassRename < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_REPLACE && !old_ast_path.target_node.empty_ast? && !new_ast_path.target_node.empty_ast? && is_name_of_class?(old_ast_path) && is_name_of_class?(new_ast_path)
    end

    def string_representation
      "renamed class #{name_of_context_class(old_ast_path)} to #{name_of_context_class(new_ast_path)}"
    end
  end
end