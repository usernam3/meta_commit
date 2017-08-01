module MetaCommit::Models::Factories
  class ParserFactory
    attr_accessor :available_parser_classes

    def initialize
      @available_parser_classes = [
          MetaCommit::Parsers::Ruby,
      ]
    end

    # @param [String] filename
    # @param [String] content
    # @return [MetaCommit::Parsers::Ruby, Nil]
    def create_parser_for(filename, content)
      @available_parser_classes.each do |parser|
        return parser.new if parser_supports(parser, filename, content)
      end
      nil
    end

    # @param [Class] parser
    # @param [String] filename
    # @param [String] content
    # @return [Boolean]
    def parser_supports(parser, filename, content)
      (parser.supported_file_extensions.any? { |ext| filename.end_with?(ext) }) && (parser.supports_syntax?(content))
    end
  end
end