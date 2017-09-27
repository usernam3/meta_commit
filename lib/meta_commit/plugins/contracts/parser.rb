module MetaCommit::Contracts
  # Parser responsibility is to build Ast node from code string
  class Parser

    # @return [Array<String>] supported extensions
    def self.supported_file_extensions
    end

    # @return [Boolean]
    def self.supports_syntax?(source_code)
    end

    # @param [String] source_code
    # @return [MetaCommit::Contracts::Ast]
    def parse(source_code)
    end
  end
end