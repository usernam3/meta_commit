module MetaCommit::Contracts
  # Diff contains data from changed element and is responsible for printing structured, user friendly message about change
  class Diff

    TYPE_ADDITION = :addition
    TYPE_DELETION = :deletion
    TYPE_REPLACE  = :replace

    SUPPORTS_ALL_PARSERS_WILDCARD = :*

    # @param [Class] parser
    # @return [Boolean]
    def supports_parser?(parser)

    end

    # @param [Symbol] type
    # @param [String] old_file_name
    # @param [String] new_file_name
    # @param [String] old_ast_path
    # @param [String] new_ast_path
    # @return [Boolean]
    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)

    end

    # @return [String]
    def to_s

    end

    # @return [String]
    def string_representation

    end

    # @return [Boolean]
    def type_addition?

    end

    # @return [Boolean]
    def type_deletion?

    end

    # @return [Boolean]
    def type_replace?

    end
  end
end