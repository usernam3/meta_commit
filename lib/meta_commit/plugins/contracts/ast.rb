module MetaCommit::Contracts
  # Structure which is returned by parser and can be traversed to collect children node information
  class Ast

    # @return [Array<MetaCommit::Contracts::Ast>] children ast
    def children

    end

    # @return [Integer, nil] line number where ast starts
    def first_line

    end

    # @return [Integer, nil] line number where ast ends
    def last_line

    end
  end
end