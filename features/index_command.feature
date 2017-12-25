Feature: Index command
  As a user
  In order to see repository with commit meta information
  I want program to add notes to repository

  Scenario: Run command on repository without notes
    Given three_commits git repository
    When I run meta_commit command `index`
    Then the output should contain exactly "repository successfully indexed"
     And the repository should have git note on "d8b7ae36232907318eaaa0052e33fa6ecb834ed6" with contents of fixture "d8b7ae36232907318eaaa0052e33fa6ecb834ed6"
     And the repository should have git note on "c3282c0b8808765b314b95f0f9287266aed531cf" with contents of fixture "c3282c0b8808765b314b95f0f9287266aed531cf"

  Scenario: Command overwrites existing notes
    Given three_commits_with_notes git repository
    When I run meta_commit command `index`
    Then the output should contain "repository successfully indexed"
     And the output should contain "Overwriting existing notes for object c3282c0b8808765b314b95f0f9287266aed531cf"
     And the repository should have git note on "d8b7ae36232907318eaaa0052e33fa6ecb834ed6" with contents of fixture "d8b7ae36232907318eaaa0052e33fa6ecb834ed6"
     And the repository should have git note on "c3282c0b8808765b314b95f0f9287266aed531cf" with contents of fixture "c3282c0b8808765b314b95f0f9287266aed531cf"
