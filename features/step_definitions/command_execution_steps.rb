Given /(\w+) git repository/ do |repository|
  git_repo_name(repository)
end

When /I run meta_commit command `([^"]*)`/ do |command|
  full_command="bundle exec meta_commit #{command} #{command_options}"
  step("I run `#{full_command}`")
end