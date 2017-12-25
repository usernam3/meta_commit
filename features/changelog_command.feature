Feature: Changelog command
  As a user
  In order to see changelog
  I want program to calculate it

  Scenario: Run command on repository with tags
    Given three_commits_with_two_tags_and_changelog git repository
    When I run meta_commit command `changelog v1.0 v2.0`
    Then the output should contain exactly "added version [v2.0] to CHANGELOG.md"
    Then the changelog should be equal to fixture file "three_commits_with_tags"
