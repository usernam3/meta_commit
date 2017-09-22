module MetaCommit::Plugin::Ruby::Diffs
  # Base class for diffs
  # @attr [Symbol] diff_type
  # @attr [String] commit_old
  # @attr [String] commit_new
  # @attr [String] old_file
  # @attr [String] new_file
  # @attr [String] old_lineno
  # @attr [String] new_lineno
  # @attr [MetaCommit::Models::ContextualAstNode] old_ast_path
  # @attr [MetaCommit::Models::ContextualAstNode] new_ast_path
  class Diff

    TYPE_ADDITION = :addition
    TYPE_DELETION = :deletion
    TYPE_REPLACE = :replace

    attr_accessor :diff_type
    attr_accessor :commit_old, :commit_new
    attr_accessor :old_file, :new_file
    attr_accessor :old_lineno, :new_lineno
    attr_accessor :old_ast_path, :new_ast_path

    # @return [String]
    def inspect
      string_representation
    end

    # @return [String]
    def to_s
      string_representation
    end

    # @return [String]
    def string_representation
      "#{diff_type} was performed"
    end

    # @param [Symbol] type
    # @return [Boolean]
    def supports_change_of_type(type)
      true
    end

    # @param [Symbol] type
    # @param [String] old_file_name
    # @param [String] new_file_name
    # @param [String] old_ast_path
    # @param [String] new_ast_path
    # @return [Boolean]
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      true
    end

    # @return [Boolean]
    def type_addition?
      @diff_type == TYPE_ADDITION
    end
    # @return [Boolean]
    def type_deletion?
      @diff_type == TYPE_DELETION
    end
    # @return [Boolean]
    def type_replace?
      @diff_type == TYPE_REPLACE
    end
  end
end