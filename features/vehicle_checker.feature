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
      And I should see "Enter the registration details of the vehicle you wish to check"

  Scenario: User enters a correct vehicle's registration and details are correct
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I should see "Vehicle type approval"
      And I should see "Model"
      And I choose that the details are correct
      And I press the Confirm
    Then I should see the CAZ Selection page

  Scenario: User enters a correct vehicle's registration but details are incorrect
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see the Incorrect Details page
      And I should see "Check vehicle compliance" title
      And I should see "Incorrect vehicle details"

  Scenario: User selects Non-UK place of registration
    Given I am on the enter details page
    Then I enter a vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see the Non-UK vehicle page

  Scenario: User doesn't fill VRN input
    Given I am on the enter details page
      And I press the Continue
    Then I should see "Enter the registration number of the vehicle"

  Scenario: User doesn't select country
    Given I am on the enter details page
      And I enter a vehicle's registration without selecting country
      And I press the Continue
    Then I should see "Tell us if your vehicle is UK or non-UK registered"

  Scenario: User fills invalid VRN
    Given I am on the enter details page
      And I enter a vehicle's registration with "C3#%&"
      And I press the Continue
    Then I should see "Enter the registration number of the vehicle in valid format"

  Scenario: User doesn't select confirmation
    Given I am on the enter details page
    And I enter a vehicle's registration
      And I press the Continue
    Then I should see the Confirm Details page
      And I press the Confirm
    Then I should see "You must choose an answer"

  Scenario: Server is unavailable
    Given I am on the home page and server is unavailable
    Then I should see the Service Unavailable page
      And I should see "Sorry, the service is unavailable"

  Scenario: User enters an exempt vehicle's registration
    Given I am on the enter details page
      And I enter an exempt vehicle's registration
      And I press the Continue
    Then I should see the Exemption page
