require 'meta_commit/version'

Then 'the output should contain gem version' do
  step("the output should contain \"#{MetaCommit::VERSION}\"")
end