Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
    Then I should see the Vehicle Checker page
      And I should see "Check vehicle compliance" title
      And I should see "Enter the registration of the vehicle you wish to check"

  Scenario: User enters a correct vehicle's registration and details are correct
    Given I am on the enter details page
    Then I should enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ Selection page

  Scenario: User enters a correct vehicle's registration but details are incorrect
    Given I am on the enter details page
    Then I should enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see "Check vehicle compliance" title
      And I should see "Incorrect vehicle details"

  Scenario: User doesn't fill inputs correctly
    Given I am on the enter details page
      And I press the Continue
    Then I should see "You must enter your registration number"
      And I should enter a vehicle's registration with "C3#%&"
      And I press the Continue
    Then I should see "You must enter your registration number in valid format"
      And I should enter a vehicle's registration with "ABC123ABC123"
      And I press the Continue
    Then I should see "Your registration number is too long"
      And I should enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I press the Confirm
    Then I should see "You must choose an answer"

  Scenario: Server is unavailable
    Given I am on the home page and server is unavailable
    Then I should see the Server Unavailable page
      And I should see "Try again later."

  Scenario: User enters an exempt vehicle's registration
    Given I am on the enter details page
      And I enter an exempt vehicle's registration
      And I press the Continue
    Then I should see the Exemption page
