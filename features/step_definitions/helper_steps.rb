# frozen_string_literal: true

Given(/^I am on the home page$/) do
  visit '/'
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end
