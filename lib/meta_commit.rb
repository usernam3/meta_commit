require "meta_commit/version"

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
require "meta_commit/models/ast_path"
require "meta_commit/models/line"
require "meta_commit/models/changes/commit"
require "meta_commit/models/changes/file"
require "meta_commit/models/changes/repository"

# diffs
require "meta_commit/models/diffs/diff"
require "meta_commit/models/diffs/class_creation"
require "meta_commit/models/diffs/class_deletion"
require "meta_commit/models/diffs/class_rename"
require "meta_commit/models/diffs/method_creation"
require "meta_commit/models/diffs/method_deletion"
require "meta_commit/models/diffs/changes_in_method"
require "meta_commit/models/diffs/module_creation"
require "meta_commit/models/diffs/module_deletion"
require "meta_commit/models/diffs/module_rename"

# factories
require "meta_commit/models/factories/diff_factory"
require "meta_commit/models/factories/ast_path_factory"
require "meta_commit/models/factories/parser_factory"

# services
require "meta_commit/services/change_saver"
require "meta_commit/services/parse"

require "meta_commit/git/repo"
require "meta_commit/parsers/ruby"

module MetaCommit
end
