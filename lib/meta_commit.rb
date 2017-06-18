require "meta_commit/version"

require "meta_commit/cli"
require "meta_commit/git/repo"

require "meta_commit/adapters/dump"
require "meta_commit/adapters/git_notes"

require "meta_commit/models/ast_path"
require "meta_commit/models/line"
require "meta_commit/models/changes/commit"
require "meta_commit/models/changes/file"
require "meta_commit/models/changes/repository"

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

require "meta_commit/models/factories/diff_factory"
require "meta_commit/models/factories/ast_path_factory"

require "meta_commit/services/diff_examiner"
require "meta_commit/services/diff_index_examiner"
require "meta_commit/services/change_saver"
require "meta_commit/services/commit_message_builder"

module MetaCommit
end
