require 'dry/container'
module MetaCommit
  class Container
    include Dry::Container::Mixin

    BUILTIN_EXTENSION = 'builtin'

    def initialize
      super
      register :parser_classes, []
      register :diff_classes, []
    end

    # @param [MetaCommit::ConfigStore] config_store
    # @return [MetaCommit::Container]
    def boot(config_store)
      load_packages(config_store.get(:extensions))

      register :diff_factory, MetaCommit::Factories::DiffFactory.new(self[:diff_classes])
      register :parser_factory, MetaCommit::Factories::ParserFactory.new(self[:parser_classes])
      register :parse_command, MetaCommit::Services::Parse.new(self[:parser_factory])
      register :contextual_ast_node_factory, MetaCommit::Factories::ContextualAstNodeFactory.new
      register :diff_lines_provider, MetaCommit::Services::DiffLinesProvider.new

      self
    end

    # @param [Array<String>] extensions_to_load
    def load_packages(extensions_to_load)
      # @TODO refactor so it search in GEM_HOME dir (?)
      required_extensions(extensions_to_load).each do |gem|
        gem.require_paths.each do |path|
          gem_source_path = File.join(gem.full_gem_path, path)
          $LOAD_PATH.unshift gem_source_path
          require gem.name
        end

        extension = extension_class(camelize(without_extension_prefix(gem.name))).new

        self[:parser_classes].concat(extension.parsers)
        self[:diff_classes].concat(extension.diffs)
      end
      load_builtin_extension if extensions_to_load.include?(BUILTIN_EXTENSION)
    end

    protected :load_packages

    def load_builtin_extension
      require 'meta_commit/extensions/builtin'

      extension = extension_class(camelize(without_extension_prefix('builtin'))).new

      self[:parser_classes].concat(extension.parsers)
      self[:diff_classes].concat(extension.diffs)
    end

    protected :load_builtin_extension

    # @param [Array<String>] extensions_to_load
    # @return [Array<String>]
    def required_extensions(extensions_to_load)
      extensions = Gem::Specification.find_all.select do |gem|
        gem.name =~ /^meta_commit_/ && gem.name != 'meta_commit_contracts' && extensions_to_load.include?(without_extension_prefix gem.name)
      end
      extensions.uniq {|gem| gem.name}
    end

    protected :required_extensions

    # @param [String] extension name
    # @return [Class] extension class
    def extension_class(extension)
      "MetaCommit::Extension::#{extension}::Locator".split('::').inject(Object) {|o, c| o.const_get(c)}
    end

    protected :extension_class

    # @param [String] extension_name
    # @return [String]
    def camelize(extension_name)
      return extension_name.slice(0, 1).capitalize + extension_name.slice(1..-1) unless extension_name.include?('_') #  capitalize only first letter if name is not in snake case
      extension_name.split('_').collect(&:capitalize).join
    end

    protected :camelize

    # @param [String] extension_name
    # @return [String]
    def without_extension_prefix(extension_name)
      extension_name.sub('meta_commit_', '')
    end

    protected :without_extension_prefix
  end
end
