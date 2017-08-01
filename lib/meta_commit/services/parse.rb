module MetaCommit::Services
  # Class#execute receives filename and text, parses text if matched parser found and returns parsed content
  class Parse
    # @param [MetaCommit::Models::Factories::ParserFactory] factory
    def initialize(factory)
      @factory=factory
    end

    # Parses content and if matched parser found returns parsed content
    # @param [String] filename
    # @param [String] content
    # @return [Object, nil]
    def execute(filename, content)
      parser = @factory.create_parser_for(filename, content)
      return nil if parser.nil?
      parser.parse(content)
    end
  end
end