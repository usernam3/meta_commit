Feature: Error message when not a valid git repository passed
  As a user
  In order to understand that I passed not a valid git repository as `--directory` option to command
  I want program to report me about it

  Scenario: Run index command
    When I run `bundle exec meta_commit index --directory=/qwe/foo/bar/baz`
    Then the output should contain "Passed directory is not a git repo"

  Scenario: Run changelog command
    When I run `bundle exec meta_commit changelog --directory=/qwe/foo/bar/baz`
    Then the output should contain "Passed directory is not a git repo"

  Scenario: Run message command
    When I run `bundle exec meta_commit message --directory=/qwe/foo/bar/baz`
    Then the output should contain "Passed directory is not a git repo"
