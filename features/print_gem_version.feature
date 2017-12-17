Feature: Print gem version
  As a user
  In order to know which version of gem is installed
  I want command to report me it

  Scenario: Run version command
    When I run meta_commit command `version`
    Then the output should contain gem version
