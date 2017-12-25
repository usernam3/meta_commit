Given /(\w+) git repository/ do |repository|
  git_repo_name(repository)
end

When /I run meta_commit command `([^"]*)`/ do |command|
  full_command="bundle exec meta_commit #{command} #{command_options}"
  step("I run `#{full_command}`")
end

Then /the changelog should be equal to fixture file "([^"]*)"/ do |file|
  changelog_file=repository_file_path(@git_repo_name, 'CHANGELOG.md')
  fixture_file=changelog_file_path(file)
  expect(File.read(changelog_file)).to eq(File.read(fixture_file))
end
