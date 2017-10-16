module MetaCommit::Errors
  class MissingRepoError < StandardError
    def initialize(msg='Passed directory is not a git repo')
      super(msg)
    end
  end
  class MissingConfigError < StandardError
    def initialize(msg='Passed config file does not exist')
      super(msg)
    end
  end
end