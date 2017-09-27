module MetaCommit::Plugin::Ruby::Diffs
  class ClassDeletion < Diff
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      type == MetaCommit::Plugin::Ruby::Diffs::Diff::TYPE_DELETION && !old_ast_path.target_node.empty_ast? && (old_ast_path.target_node.is_class? || is_name_of_class?(old_ast_path))
    end

    def string_representation
      if @old_ast_path.target_node.is_class?
        if is_in_context_of_module?(@old_ast_path)
          return "removed class #{old_ast_path.target_node.class_name} from module #{name_of_context_module(old_ast_path)}"
        end
      end
      "removed class #{name_of_context_class(old_ast_path)}"
    end
  end
end