module MetaCommit
  module Plugin
  end

  require "meta_commit/version"
  require "meta_commit/errors"
  require "meta_commit/configuration"
  require "meta_commit/application"
  require "meta_commit/cli"

  # changelog command
  require "meta_commit/changelog/adapters/changelog"
  require "meta_commit/changelog/commands/commit_diff_examiner"
  require "meta_commit/changelog/formatters/keep_a_changelog_ver_report_builder"

  # message command
  require "meta_commit/message/commands/diff_index_examiner"
  require "meta_commit/message/formatters/commit_message_builder"

  # index command
  require "meta_commit/index/commands/diff_examiner"
  require "meta_commit/index/adapters/git_notes"

  # models
  require "meta_commit/models/contextual_ast_node"
  require "meta_commit/models/line"
  require "meta_commit/models/changes/commit"
  require "meta_commit/models/changes/file"
  require "meta_commit/models/changes/repository"
  require "meta_commit/models/diffs/diff"

  # factories
  require "meta_commit/factories/diff_factory"
  require "meta_commit/factories/contextual_ast_node_factory"
  require "meta_commit/factories/parser_factory"

  # services
  require "meta_commit/services/change_saver"
  require "meta_commit/services/parse"
  require "meta_commit/git/repo"
end

# @TODO make before application runs
configuration = MetaCommit::Configuration.new
configuration.set(:plugin_folder, File.join(File.expand_path(File.dirname(__FILE__)), 'meta_commit', 'plugins'))
application = MetaCommit::Application.instance
application.configuration=configuration
application.boot
# @TODO make before application runs
