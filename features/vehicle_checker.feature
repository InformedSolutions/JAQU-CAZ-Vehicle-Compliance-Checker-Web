Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle’s registration

  Scenario: User enter a vehicle’s registration
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
    Then I should see the Vehicle Checker page
      And I should see "Check vehicle compliance" title
      And I should see "Enter the registration of the vehicle you wish to check"
    Then I should enter a vehicle’s registration
      And I press the Continue
    Then I should see the Confirm Details page
