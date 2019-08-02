# frozen_string_literal: true

include MockHelpers

def vrn
  'CU57ABC'
end

Given(/^I am on the home page$/) do
  mock_caz
  visit '/'
end

Given('I am on the home page and server is unavailable') do
  mock_unavailable_caz
  visit '/'
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I press the Continue') do
  click_button 'Continue'
end

Then('I press the Confirm') do
  click_button 'Confirm'
end
