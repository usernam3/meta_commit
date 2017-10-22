module MetaCommit::Message
  module Formatters
    # Class builds message to commit changes
    class CommitMessageBuilder
      # @param [Array<MetaCommit::Contracts::Diff>] diffs
      # @return [String]
      def build(diffs)
        result = []
        diffs.each do |diff|
          result << "- #{diff.string_representation} \n"
        end
        result.uniq.join
      end
    end
  end
end