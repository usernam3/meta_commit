module MetaCommit::Contracts::Errors
  class SourceCodeParsingError < StandardError
    def initialize(msg='This content can not be parsed')
      super(msg)
    end
  end
end