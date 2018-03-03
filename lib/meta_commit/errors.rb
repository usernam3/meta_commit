module MetaCommit::Errors
  class MissingRepoError < StandardError
    def initialize(msg='Passed directory is not a git repo')
      super(msg)
    end
  end
  class MissingConfigError < StandardError
    def initialize(msg='Config file can not be found')
      super(msg)
    end
  end
end