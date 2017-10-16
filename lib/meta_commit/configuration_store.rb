module MetaCommit
  #
  # @attr [MetaCommit::Configuration] configuration
  class ConfigurationStore
    META_COMMIT_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    DEFAULT_FILE = File.join(META_COMMIT_HOME, 'config', 'default.yml')
    META_COMMIT_CONFIG_FILENAME = '.meta_commit.yml'

    # @param [MetaCommit::Configuration] configuration
    def initialize(configuration)
      @configuration = configuration
    end

    # Merges passed configuration with @configuration
    # @param [MetaCommit::Configuration] configuration
    # @return [MetaCommit::ConfigurationStore]
    def merge(configuration)
      @configuration.merge!(configuration)
    end

    # @param [Symbol] key
    # @return [Object]
    def get(key)
      @configuration.get(key)
    end
  end
end
