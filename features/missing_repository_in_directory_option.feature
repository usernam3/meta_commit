Feature: Error message when not a valid git repository passed
  As a user
  In order to understand that I passed not a valid git repository as `--directory` option to command
  I want program to report me about it

  Scenario: Run index command
    Given missing git repository
    When I run meta_commit command `index`
    Then the output should contain "Passed directory is not a git repo"

  Scenario: Run changelog command
    Given missing git repository
    When I run meta_commit command `changelog`
    Then the output should contain "Passed directory is not a git repo"

  Scenario: Run message command
    Given missing git repository
    When I run meta_commit command `message`
    Then the output should contain "Passed directory is not a git repo"
