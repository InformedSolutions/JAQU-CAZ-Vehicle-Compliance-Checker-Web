# frozen_string_literal: true

Given('I am on the enter details page') do
  visit enter_details_vehicle_checkers_path
end

Then('I press the Start now button') do
  click_link 'Start now'
end

Then('I should see the Vehicle Checker page') do
  expect(page).to have_current_path(enter_details_vehicle_checkers_path)
end

Then("I enter a vehicle's registration") do
  fill_in('vrn', with: vrn)
  choose('UK')
  mock_vehicle_details
end

Then("I enter a vehicle's registration without selecting country") do
  fill_in('vrn', with: vrn)
  mock_vehicle_details
end

Then("I enter a vehicle's registration and choose Non-UK") do
  fill_in('vrn', with: vrn)
  choose('Non-UK')
  mock_vehicle_details
end

Then("I enter a vehicle's registration with {string}") do |string|
  fill_in('vrn', with: string)
  choose('UK')
  mock_vehicle_details
end

Then('I press the Continue when server is unavailable') do
  mock_unavailable_vehicle_details
  click_button 'Continue'
end

Then('I should see the Confirm Details page') do
  expect(page).to have_current_path(confirm_details_vehicle_checkers_path, ignore_query: true)
end

Then('I choose that the details are correct') do
  mock_caz
  choose('Yes')
end

Then('I choose that the details are incorrect') do
  choose('No')
end

Then('I should see the Incorrect Details page') do
  expect(page).to have_current_path(incorrect_details_vehicle_checkers_path, ignore_query: true)
end

Then('I press the Search Again link') do
  click_link 'search again'
end

Then('I should see the CAZ Selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path, ignore_query: true)
end

Then('I should see the Server Unavailable page') do
  expect(page).to have_current_path(server_unavailable_path)
end

And("I enter an exempt vehicle's registration") do
  fill_in('vrn', with: vrn)
  choose('UK')
  mock_exempt_vehicle_details
end

Then('I should see the Exemption page') do
  expect(page).to have_current_path(exemption_vehicle_checkers_path)
end

Then('I should see the Non-UK vehicle page') do
  expect(page).to have_current_path(non_uk_vehicle_checkers_path)
end
