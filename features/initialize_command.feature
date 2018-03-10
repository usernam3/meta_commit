Feature: Index command
  As a user
  In order to see prepare repository to use with meta_commit
  I want program to add configuration file

  Scenario: Run command on repository without configuration file
    Given empty_repository git repository
    When I run meta_commit command `init`
    Then the repository should have file ".meta_commit.yml" with contents of fixture "valid_with_builtin_extension.yml"
     And the output should contain "The configuration file .meta_commit.yml added"

  Scenario: Run command on repository with configuration file
    Given three_commits_with_notes git repository
    When I run meta_commit command `init`
    Then the output should contain "Configuration file exists. You repository is already meta_commit compatible."

  Scenario: Run command with passed extensions
    Given empty_repository git repository
    When I run meta_commit command `init --extensions=ruby_support markdown_support`
    Then the repository should have file ".meta_commit.yml" with contents of fixture "ruby_and_markdown_extensions.yml"
