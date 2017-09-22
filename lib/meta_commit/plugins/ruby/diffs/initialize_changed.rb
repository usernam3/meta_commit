module MetaCommit::Plugin::Ruby::Diffs
  class InitializeChanged < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_REPLACE &&
          !old_ast_path.empty_ast? && !new_ast_path.empty_ast? &&
          old_ast_path.is_in_context_of_method? && new_ast_path.is_in_context_of_method? &&
          old_ast_path.name_of_context_method == 'initialize' && new_ast_path.name_of_context_method == 'initialize'
    end

    def string_representation
      "changes in initialization of #{new_ast_path.path_to_component(0)}"
    end
  end
end