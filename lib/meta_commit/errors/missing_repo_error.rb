module MetaCommit::Errors
  class MissingRepoError < StandardError
    def initialize(msg='Passed directory is not a git repo')
      super(msg)
    end
  end
end