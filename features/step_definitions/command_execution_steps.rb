Given /(\w+) git repository/ do |repository|
  git_repo_name(repository)
end

When /I run meta_commit command `([^"]*)`/ do |command|
  full_command="bundle exec meta_commit #{command} #{command_options}"
  step("I run `#{full_command}`")
end

Then /the changelog should be equal to fixture file "([^"]*)"/ do |file|
  changelog_file=repository_file_path(@git_repo_name, 'CHANGELOG.md')
  fixture_file=fixture_changelog_file_path(file)
  expect(File.read(changelog_file)).to eq(File.read(fixture_file))
end

Then /the repository should have git note on "([^"]*)" with contents of fixture "([^"]*)"/ do |object, fixture_note|
  git_dir=repository_file_path(@git_repo_name, '.git')
  actual=`git --git-dir=#{git_dir} notes show #{object}`
  expected=fixture_note_file_path(@git_repo_name, fixture_note)
  expect(actual).to eq(File.read(expected))
end