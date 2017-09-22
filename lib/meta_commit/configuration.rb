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

    # @param [Hash] hash
    # @return [MetaCommit::Configuration]
    def fill_from_hash(hash)
      hash.each { |key, value| set(key.to_sym, value) }
    end
  end
end