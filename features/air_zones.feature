Feature: Air Zone
  In order to read the page
  As a user
  I want to be able to choose a clean air zone (CAZ)
    And see details of a CAZ

  Scenario: User with correct vehicle’s registration
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose 'No' when confirms what vehicle a taxi or private hire vehicle
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm
    Then I should see the Compliance page
      And I should see 'Clean Air Zone charge'

  Scenario: When server returns 422 status
    Given I am on the enter details page
    Then I enter a vehicle's registration
      And I press the Continue
    Then I choose 'No' when confirms what vehicle a taxi or private hire vehicle
      And I choose 'Yes' when confirms vehicle details
      And I press the Confirm when server returns 422 status
    Then I should see the Cannot determine compliance page
      And I should see 'Vehicle details are incomplete'
