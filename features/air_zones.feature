Feature: Air Zone
  In order to read the page
  As a user
  I want to be able to choose a clean air zone (CAZ)
    And see details of a CAZ

  Scenario: User with correct vehicle’s registration selects CAZs
    Given I am on the CAZ selection page
      And I choose the caz zone
      And I press the Continue
    Then I should see the Compliance page

  Scenario: User with correct vehicle’s registration does not select any CAZ
    Given I am on the CAZ selection page
      And I press the Continue
    Then I should see the CAZ selection page
      And I should see "You must select at least one Clean Air Zone"
