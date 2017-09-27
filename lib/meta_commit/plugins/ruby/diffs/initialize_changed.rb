module MetaCommit::Plugin::Ruby::Diffs
  class InitializeChanged < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_REPLACE &&
          !old_ast_path.target_node.empty_ast? && !new_ast_path.target_node.empty_ast? &&
          is_in_context_of_method?(old_ast_path) && is_in_context_of_method?(new_ast_path) &&
          name_of_context_method(old_ast_path) == 'initialize' && name_of_context_method(new_ast_path) == 'initialize'
    end

    def string_representation
      "changes in initialization of #{path_to_component(new_ast_path, 0)}"
    end
  end
end