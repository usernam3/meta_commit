require 'thor'

module MetaCommit
  class ApplicationInterface < Thor

    desc 'message', 'generate message with summary of changes in repo located at DIRECTORY (or current directory if argument not passed)'
    option :directory, :type => :string, :default => Dir.pwd

    def message
      repository_path = options[:directory]
      repository = MetaCommit::Git::Repo.new(repository_path)
      container = boot_container_with_config(File.join(repository_path, MetaCommit::ConfigurationStore::META_COMMIT_CONFIG_FILENAME))

      examiner = MetaCommit::Message::Commands::DiffIndexExaminer.new(
          container.resolve(:parse_command),
          container.resolve(:contextual_ast_node_factory),
          container.resolve(:diff_factory)
      )

      meta = examiner.index_meta(repository)

      say(MetaCommit::Message::Formatters::CommitMessageBuilder.new.build(meta))
    end

    desc 'changelog [FROM_TAG] [TO_TAG]', 'writes all changes between git tags to changelog file'
    option :directory, :type => :string, :default => Dir.pwd
    option :filename, :type => :string, :default => 'CHANGELOG.md', :desc => 'Filename of changelog'

    def changelog(from_tag=nil, to_tag=nil)
      repository_path = options[:directory]
      filename = options[:filename]
      repository = MetaCommit::Git::Repo.new(repository_path)
      from_tag_commit = repository.commit_of_tag(from_tag)
      to_tag_commit = repository.commit_of_tag(to_tag)
      container = boot_container_with_config(File.join(repository_path, MetaCommit::ConfigurationStore::META_COMMIT_CONFIG_FILENAME))

      examiner = MetaCommit::Changelog::Commands::CommitDiffExaminer.new(
          container.resolve(:parse_command),
          container.resolve(:contextual_ast_node_factory),
          container.resolve(:diff_factory)
      )

      meta = examiner.meta(repository, from_tag_commit, to_tag_commit)

      adapter = MetaCommit::Changelog::Adapters::Changelog.new(repository.dir, filename, to_tag, to_tag_commit.time.strftime('%Y-%m-%d'))
      change_saver = MetaCommit::Services::ChangeSaver.new(repository, adapter)
      change_saver.store_meta(meta)
      say("added version [#{to_tag}] to #{filename}")
    end

    desc 'index', 'indexing repository'
    option :directory, :type => :string, :default => Dir.pwd

    def index
      repository_path = options[:directory]
      repository = MetaCommit::Git::Repo.new(repository_path)
      container = boot_container_with_config(File.join(repository_path, MetaCommit::ConfigurationStore::META_COMMIT_CONFIG_FILENAME))

      examiner = MetaCommit::Index::Commands::DiffExaminer.new(
          container.resolve(:parse_command),
          container.resolve(:contextual_ast_node_factory),
          container.resolve(:diff_factory)
      )

      meta = examiner.meta(repository)

      adapter = MetaCommit::Index::Adapters::GitNotes.new(repository.path)
      change_saver = MetaCommit::Services::ChangeSaver.new(repository, adapter)
      change_saver.store_meta(meta)
      say('repository successfully indexed')
    end

    desc 'version', 'prints meta_commit gem version'

    def version
      say(MetaCommit::VERSION)
    end

    no_commands do
      # @param [String] configuration_path
      # @return [MetaCommit::Container]
      def boot_container_with_config(configuration_path)
        default_configuration = MetaCommit::Configuration.new.fill_from_yaml_file(MetaCommit::ConfigurationStore::DEFAULT_FILE)
        configuration_store = MetaCommit::ConfigurationStore.new(default_configuration)
        configuration_store.merge(MetaCommit::Configuration.new.fill_from_yaml_file(configuration_path)) if File.exist?(configuration_path)

        container = MetaCommit::Container.new
        container.boot(configuration_store)
      end
    end
  end
end