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

    desc 'changelog', 'IS NOT IMPLEMENTED'
    def changelog(path=nil)
      raise('IS NOT IMPLEMENTED')
    end

    desc 'index [DIRECTORY]', 'indexing repository located at DIRECTORY (or current directory if argument not passed)'
    def index(repository_path=nil)
      repository_path ||= Dir.pwd
      repository = MetaCommit::Git::Repo.new(repository_path)
      examiner = MetaCommit::Services::DiffExaminer.new(repository)
      meta = examiner.meta
      change_saver = MetaCommit::Services::ChangeSaver.new(repository)
      change_saver.store_meta(meta)
      say('repository successfully indexed')
    end
  end
end