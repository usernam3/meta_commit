require 'singleton'
module MetaCommit
  # Boots application and loads
  # @attr [MetaCommit::Configuration] configuration
  # @attr [Array<Class>] parser_classes
  # @attr [Array<Class>] diff_classes
  class Application
    include Singleton

    PLUGIN_LOADER_FILE_NAME = 'plugin.rb'

    attr_accessor :configuration
    attr_reader :parser_classes, :diff_classes

    def initialize
      @parser_classes = []
      @diff_classes = []
    end

    # Builds packages map, loads exported classes
    # @return [Boolean]
    def boot
      load_packages
    end

    # @return [Nil]
    def load_packages
      path = File.join(@configuration.get(:plugin_folder), '**', PLUGIN_LOADER_FILE_NAME)
      files = Dir.glob(path)
      files.each do |file|
        require "#{file}"
        directory = File.basename(File.dirname(file))
        extension = extension_class(directory).new
        @parser_classes += extension.parsers
        @diff_classes += extension.diffs
      end
    end

    private :load_packages

    # @param [String] plugin folder name
    # @return [Class] plugin class
    def extension_class(plugin)
      "MetaCommit::Plugin::#{plugin.capitalize}::Locator".split('::').inject(Object) { |o, c| o.const_get(c) }
    end

    private :extension_class
  end
end