require "parser/current"
module MetaCommit::Parsers
  class Ruby
    def self.supported_file_extensions
      ['rb']
    end

    def self.supports_syntax?(source_code)
      begin
        Parser::CurrentRuby.parse(source_code)
      rescue Parser::SyntaxError
        return false
      end
      true
    end

    def parser
      @parser ||= Parser::CurrentRuby
    end

    protected :parser

    # @param [String] source_code
    def parse(source_code)
      parser.parse(source_code)
    end

    # @param [Integer] line
    # def get_path_to_ast_line(ast, line)
    #
    # end
  end
end