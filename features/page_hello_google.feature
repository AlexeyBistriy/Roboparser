Feature: Log in Welcome Google
  As a analyst
  I want to visit the Google!
  So then I get access to useful information

  Scenario:
    Given the url address "https://www.google.com/"
    When I start a new game
    Then I should see "Welcome to Codebreaker!"
    And I should see "Enter guess:"