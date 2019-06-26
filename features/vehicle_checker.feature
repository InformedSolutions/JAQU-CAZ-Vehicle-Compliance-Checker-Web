Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle’s registration
    And see details of a car

  Scenario: User enter a correct vehicle’s registration
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
    Then I should see the Vehicle Checker page
      And I should see "Check vehicle compliance" title
      And I should see "Enter the registration of the vehicle you wish to check"
    Then I should enter a vehicle’s registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I press the Search Again link
    Then I should enter a vehicle’s registration
      And I press the Continue
    Then I should see the Confirm Details page

