Feature: Privacy Notice
  In order to read the page
  As a user
  I want to see privacy notice page

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press "Privacy" footer link
    Then I should see "Check if you’ll be charged to drive in a Clean Air Zone"
