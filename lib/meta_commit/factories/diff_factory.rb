module MetaCommit::Factories
  # Diff factory
  # @attr [Array<Class>] available_diff_classes diff classes that factory can build
  class DiffFactory
    attr_accessor :available_diff_classes

    def initialize(diff_classes)
      @available_diff_classes = diff_classes
    end

    # Factory method
    # @param [Symbol] type
    # @param [Hash] options
    # @return [Diff, nil] created diff or nil if matched diff not found
    def create_diff_of_type(type, options)
      @available_diff_classes.each do |diff_class|
        diff = diff_class.new
        if diff.supports_parser?(options[:old_contextual_ast].parser_class) &&
            diff.supports_parser?(options[:new_contextual_ast].parser_class) &&
            diff.supports_change(type, options[:old_file_path], options[:new_file_path], options[:old_contextual_ast], options[:new_contextual_ast])
          line = options[:line]
          diff.diff_type = line.line_origin
          diff.commit_old = options[:commit_id_old]
          diff.commit_new = options[:commit_id_new]
          diff.old_file = options[:old_file_path]
          diff.new_file = options[:new_file_path]
          diff.old_lineno = line.old_lineno
          diff.new_lineno = line.new_lineno
          diff.old_ast_path = options[:old_contextual_ast]
          diff.new_ast_path = options[:new_contextual_ast]
          return diff
        end
      end
      nil
    end
  end
end