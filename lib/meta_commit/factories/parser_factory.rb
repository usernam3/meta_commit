module MetaCommit::Factories
  # Parser factory
  # @attr [Array<Class>] available_parser_classes parser classes that factory can build
  class ParserFactory
    attr_accessor :available_parser_classes

    # @param [Array<Class>] parser_classes
    def initialize(parser_classes)
      @available_parser_classes = parser_classes
    end

    # @param [String] filename
    # @param [String] content
    # @return [MetaCommit::Contracts::Parser, Nil]
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
      (parser.supported_file_extensions.any? {|ext| filename.end_with?(ext)}) && (parser.supports_syntax?(content))
    end
  end
end