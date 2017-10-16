require 'yaml'
module MetaCommit
  class Configuration < Hash
    # Set the configuration key
    # @param key [Symbol] configuration key
    # @param value [Object] configuration value
    def set(key, value)
      self[key] = value
    end

    # Get the configuration value by key
    # @param key [Symbol] configuration key
    # @return [Object] configuration value
    def get(key)
      self[key]
    end

    # Fill config values from yaml file
    # @param [Hash] hash
    # @return [MetaCommit::Configuration]
    def fill_from_hash(hash)
      hash.each {|key, value| set(key.to_sym, value)}
      self
    end

    # Fill config values from yaml file
    # @param [String] path
    # @return [MetaCommit::Configuration]
    def fill_from_yaml_file(path)
      fill_from_hash read_from_yaml(path)
    end

    # @param [String] path
    # @return [Hash]
    def read_from_yaml(path)
      begin
        YAML::load_file(path)
      rescue Errno::ENOENT => e
        raise MetaCommit::Errors::MissingConfigError
      end
    end

    protected :read_from_yaml
  end
end