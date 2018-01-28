module MetaCommit::Factories
  # Diff factory
  # @attr [Array<Class>] available_diff_classes diff classes that factory can build
  class DiffFactory
    attr_accessor :available_diff_classes

    # @param [Array<Class>] diff_classes
    def initialize(diff_classes)
      @available_diff_classes = diff_classes
    end

    # Factory method
    # @param [Hash] options
    # @return [Diff, nil] created diff or nil if matched diff not found
    def create_diff(options)
      context = change_context(options)
      @available_diff_classes.each do |diff_class|
        diff = diff_class.new
        if diff.supports_parser?(context.old_contextual_ast.parser_class) &&
            diff.supports_parser?(context.new_contextual_ast.parser_class) &&
            diff.supports_change(context)
          diff.change_context = context
          return diff
        end
      end
      nil
    end

    private
    # Convert hash to context object
    # @param [Hash] options
    # @return [MetaCommit::Contracts::ChangeContext]
    def change_context(options)
      context = MetaCommit::Contracts::ChangeContext.new
      context.type = options[:line].line_origin
      context.old_lineno = options[:line].old_lineno
      context.new_lineno = options[:line].new_lineno
      context.commit_id_old = options[:commit_id_old]
      context.commit_id_new = options[:commit_id_new]
      context.old_contextual_ast = options[:old_contextual_ast]
      context.new_contextual_ast = options[:new_contextual_ast]
      context.old_file_path = options[:old_file_path]
      context.new_file_path = options[:new_file_path]
      context
    end
  end
end