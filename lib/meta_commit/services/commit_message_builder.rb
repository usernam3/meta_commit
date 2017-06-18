module MetaCommit::Services
  class CommitMessageBuilder
    attr_accessor :repo

    def initialize(repo)
      @repo = repo
    end

    def build(commit_change)
      message = []
      commit_change.each do |file_change|
        file_change.each do |diff|
          message.push(build_message_for_diff(diff))
        end
      end
      message.join("\n")
    end

    def build_message_for_diff(diff)
      diff.to_s
    end
  end
end