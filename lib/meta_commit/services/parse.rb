module MetaCommit::Services
  # Parse service responsibility is to parse text if matched parser found and return parsed content
  class Parse
    # @param [MetaCommit::Factories::ParserFactory] factory
    def initialize(factory)
      @factory=factory
    end

    # Parses content and if matched parser found returns parsed content
    # @param [String] filename
    # @param [String] content
    # @return [MetaCommit::Plugin::Ruby::Models::Ast, nil]
    def execute(filename, content)
      parser = @factory.create_parser_for(filename, content)
      return nil if parser.nil?
      parser.parse(content)
    end
  end
end