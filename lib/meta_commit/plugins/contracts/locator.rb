module MetaCommit::Contracts
  # Locator responsibility is to export parser classes and diff classes of package
  class Locator

    # @return [Array<Class>] parser classes that package provides
    def parsers
    end

    # @return [Array<Class>] diff classes that package provides
    def diffs
    end
  end
end