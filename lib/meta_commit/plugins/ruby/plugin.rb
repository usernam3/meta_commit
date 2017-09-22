module MetaCommit::Plugin::Ruby
end
# ruby extension
require "meta_commit/plugins/ruby/parsers/ruby"
# ruby extension diffs
require "meta_commit/plugins/ruby/diffs/diff"
require "meta_commit/plugins/ruby/diffs/class_creation"
require "meta_commit/plugins/ruby/diffs/class_deletion"
require "meta_commit/plugins/ruby/diffs/class_rename"
require "meta_commit/plugins/ruby/diffs/method_creation"
require "meta_commit/plugins/ruby/diffs/method_deletion"
require "meta_commit/plugins/ruby/diffs/changes_in_method"
require "meta_commit/plugins/ruby/diffs/module_creation"
require "meta_commit/plugins/ruby/diffs/module_deletion"
require "meta_commit/plugins/ruby/diffs/module_rename"
require "meta_commit/plugins/ruby/diffs/initialize_changed"
require "meta_commit/plugins/ruby/locator"