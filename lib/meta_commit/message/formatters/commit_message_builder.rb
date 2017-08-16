module MetaCommit::Message
  module Formatters
    # Class builds message to commit changes
    class CommitMessageBuilder
      # @param [Array<MetaCommit::Models::Diffs::Diff>] diffs
      # @return [String]
      def build(diffs)
        result = ''
        diffs.each do |diff|
          result << "- #{diff.string_representation} \n"
        end
        result
      end
    end
  end
end