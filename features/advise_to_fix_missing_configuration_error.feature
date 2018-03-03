Feature: Advise how to fix 'missing configuration error'

  Scenario Outline: Run <command> on repository without configuration file
    Given three_commits_without_config git repository
    When I run meta_commit command `<command>`
    Then the output should contain "Please, run `meta_commit init` to create configuration file"

    Examples:
      | command   |
      | index     |
      | message   |
      | changelog |