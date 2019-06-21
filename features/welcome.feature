Feature: Welcome
  In order to read the page
  As a user
  I want to see the welcome page

  Scenario: User see welcome page
    When I go to the home page
    Then I should see "Check a vehicle's Clean Air Zone compliance"
      And I should see "Clean Air Zone" title
