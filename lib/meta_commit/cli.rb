require 'thor'

module MetaCommit
  class ApplicationInterface < Thor
    desc 'message', 'generate message with summary of changes in repo located at DIRECTORY (or current directory if argument not passed)'
    option :directory, :type => :string, :default => Dir.pwd

    def message
      repository_path = options[:directory]
      repository = MetaCommit::Git::Repo.new(repository_path)

      diff_factory = MetaCommit::Factories::DiffFactory.new(MetaCommit::Application.instance.diff_classes)
      parser_factory = MetaCommit::Factories::ParserFactory.new(MetaCommit::Application.instance.parser_classes)
      examiner = MetaCommit::Message::Commands::DiffIndexExaminer.new(
          MetaCommit::Services::Parse.new(parser_factory),
          MetaCommit::Factories::ContextualAstNodeFactory.new,
          diff_factory
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

      diff_factory = MetaCommit::Factories::DiffFactory.new(MetaCommit::Application.instance.diff_classes)
      parser_factory = MetaCommit::Factories::ParserFactory.new(MetaCommit::Application.instance.parser_classes)
      examiner = MetaCommit::Changelog::Commands::CommitDiffExaminer.new(
          MetaCommit::Services::Parse.new(parser_factory),
          MetaCommit::Factories::ContextualAstNodeFactory.new,
          diff_factory
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

      diff_factory = MetaCommit::Factories::DiffFactory.new(MetaCommit::Application.instance.diff_classes)
      parser_factory = MetaCommit::Factories::ParserFactory.new(MetaCommit::Application.instance.parser_classes)
      examiner = MetaCommit::Index::Commands::DiffExaminer.new(
          MetaCommit::Services::Parse.new(parser_factory),
          MetaCommit::Factories::ContextualAstNodeFactory.new,
          diff_factory
      )
      meta = examiner.meta(repository)
      adapter = MetaCommit::Index::Adapters::GitNotes.new(repository.path)
      change_saver = MetaCommit::Services::ChangeSaver.new(repository, adapter)
      change_saver.store_meta(meta)
      say('repository successfully indexed')
    end
  end
end