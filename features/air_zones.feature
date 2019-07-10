Feature: Air Zone
  In order to read the page
  As a user
  I want to be able to choose a clean air zone (CAZ)
    And see details of a CAZ

  Scenario: User enter a correct vehicle’s registration and details are correct
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
      And I should enter a vehicle's registration
      And I press the Continue
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ selection page
      And I press the Continue
    Then I should see the CAZ selection page
      And I should see "You must choose clean air zones"
      And I choose the caz zone
      And I press the Continue on CAZ selection page
    Then I should see the Compliance page
