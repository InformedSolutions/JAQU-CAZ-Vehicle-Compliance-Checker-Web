Feature: Contact Form
  In order to read the page
  As a user
  I want to be able to send a contact form

  Scenario: User wants to send a contact form
    Given I am on the Contact Form page
      And I should see "Contact Form"
      And I fill all fields and press Send button
    Then I should see the Result page
      And I should see "Contact form was sent"

  Scenario: Filling not all required fields
    Given I am on the Contact Form page
      And I am not fill First Name field and press Send button
    Then I remain on the Contact Form page
      And I should see "First name is required"
    Then I am not fill Last Name field and press Send button
      And I should see "Last name is required"
    Then I am not fill Email Address field and press Send button
      And I should see "Email is required"
    Then I am not fill Email Confirmation field and press Send button
      And I should see "Email confirmation is required"
    Then I am not select any Query Type and press Send button
      And I should see "Query type is required"
    Then I am not fill Message field and press Send button
      And I should see "Message is required"

  Scenario: Filling not the same email and email confirmation addresses
    Given I am on the Contact Form page
      And I fill not the same email and email_confirmation fields and press Send button
    Then I remain on the Contact Form page
      And I should see "Email and email address confirmation must be the same"

  Scenario: Filling too long message
    Given I am on the Contact Form page
      And I fill too long message and press Send button
    Then I remain on the Contact Form page
      And I should see "Message is too long (maximum is 2000 characters)"

