require 'thor'

module MetaCommit
  class ApplicationInterface < Thor
    desc 'message [DIRECTORY]', 'generate message with summary of changes in repo located at DIRECTORY (or current directory if argument not passed)'
    def message(repository_path=nil)
      repository_path ||= Dir.pwd
      repository = MetaCommit::Git::Repo.new(repository_path)
      examiner = MetaCommit::Services::DiffIndexExaminer.new(repository)
      meta = examiner.index_meta
      message_builder = MetaCommit::Services::CommitMessageBuilder.new(repository)
      message = message_builder.build(meta)
      say(message)
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
      examiner = MetaCommit::Services::DiffCommitExaminer.new(repository)
      meta = examiner.meta(from_tag_commit, to_tag_commit)
      adapter = MetaCommit::Adapters::Changelog.new(repository.dir, filename, to_tag, to_tag_commit.time.strftime('%Y-%m-%d'))
      change_saver = MetaCommit::Services::ChangeSaver.new(repository, adapter)
      change_saver.store_meta(meta)
      say("added version [#{to_tag}] to #{filename}")
    end

    desc 'index [DIRECTORY]', 'indexing repository located at DIRECTORY (or current directory if argument not passed)'
    def index(repository_path=nil)
      repository_path ||= Dir.pwd
      repository = MetaCommit::Git::Repo.new(repository_path)
      examiner = MetaCommit::Services::DiffExaminer.new(repository)
      meta = examiner.meta
      adapter = MetaCommit::Adapters::GitNotes.new(repository.repo.path)
      change_saver = MetaCommit::Services::ChangeSaver.new(repository, adapter)
      change_saver.store_meta(meta)
      say('repository successfully indexed')
    end
  end
end