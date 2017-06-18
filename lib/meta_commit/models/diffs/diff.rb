module MetaCommit::Models::Diffs
  class Diff

    TYPE_ADDITION = :addition
    TYPE_DELETION = :deletion
    TYPE_REPLACE = :replace

    attr_accessor :diff_type
    attr_accessor :commit_old, :commit_new
    attr_accessor :old_file, :new_file
    attr_accessor :old_lineno, :new_lineno
    attr_accessor :old_ast_path, :new_ast_path

    def inspect
      string_representation
    end

    def to_s
      string_representation
    end

    def string_representation
      "#{diff_type} was performed"
    end

    def supports_change_of_type(type)
      true
    end

    def supports_change(type, old_file_name, new_file_name, old_ast_path, new_ast_path)
      true
    end
  end
end