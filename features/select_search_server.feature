Feature: Select search server
  As a internet user
  I want to choose a search server and know that it is available
  So then I can do a search for more effective and to know that I used the right search server

#  Scenario: The chosen server is unavailable
#    Given a default list of server names
#    When I select server <name>
#    Then I should see "server <url> is unavailable"
#    And I should see "Please try again later..."
#
#
#  Scenario Outline: The chosen server is available
#    Given I see list of server names
#    When I select server <name>
#    Then I should see "server <url> is unavailable"
#    And I should see "Welcome in <name>"
#
#   Scenarios: Search Server
#      | name | url |
#      | Google | https://www.google.com |
#      | Yandex | http://yandex.ua |
#      | Rambler | http://www.rambler.ru/ |
#      | Yahoo | https://www.yahoo.com/ |
#      | Bing  | https://www.bing.com/ |
#      | DuckDuckGo | https://duckduckgo.com/ |
#
    Scenario Outline: Verification of the available server.

      Given a server "<name>" with "<url>"
#      When I connect to the "<url>"
#      And server available
#      Then I should see "server <url> is available"
#      And I should see "Welcome in <name>"

    Scenarios: Search Server
      | name | url |
      | Google | https://www.google.com |



