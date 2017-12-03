require 'meta_commit/version'

Then 'the output should contain gem version' do
  expect(last_command_started).to have_output(MetaCommit::VERSION)
end