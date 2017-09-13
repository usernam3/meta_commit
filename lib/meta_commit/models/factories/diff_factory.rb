module MetaCommit::Models::Factories
  # Diff factory
  # @attr [Array] available_diff_classes diff classes that factory can build
  class DiffFactory
    attr_accessor :available_diff_classes

    def initialize
      @available_diff_classes = [
          MetaCommit::Models::Diffs::InitializeChanged,
          MetaCommit::Models::Diffs::ClassCreation,
          MetaCommit::Models::Diffs::ClassDeletion,
          MetaCommit::Models::Diffs::ClassRename,
          MetaCommit::Models::Diffs::MethodCreation,
          MetaCommit::Models::Diffs::MethodDeletion,
          MetaCommit::Models::Diffs::ChangesInMethod,
          MetaCommit::Models::Diffs::ModuleCreation,
          MetaCommit::Models::Diffs::ModuleDeletion,
          MetaCommit::Models::Diffs::ModuleRename,
          MetaCommit::Models::Diffs::Diff,
      ]
    end

    # Factory method
    # @param [Symbol] type
    # @param [Hash] options
    # @return [Diff, nil] created diff or nil if matched diff not found
    def create_diff_of_type(type, options)
      @available_diff_classes.each do |diff_class|
        diff = diff_class.new
        if diff.supports_change(type, options[:old_file_path], options[:new_file_path], options[:old_ast_path], options[:new_ast_path])
          line = options[:line]
          diff.diff_type = line.line_origin
          diff.commit_old = options[:commit_id_old]
          diff.commit_new = options[:commit_id_new]
          diff.old_file = options[:old_file_path]
          diff.new_file = options[:new_file_path]
          diff.old_lineno = line.old_lineno
          diff.new_lineno = line.new_lineno
          diff.old_ast_path = options[:old_ast_path]
          diff.new_ast_path = options[:new_ast_path]
          return diff
        end
      end
      nil
    end
  end
end