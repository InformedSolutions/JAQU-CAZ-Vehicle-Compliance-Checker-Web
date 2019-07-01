# frozen_string_literal: true

Then('I press the Start now button') do
  click_link 'Start now'
end

Then('I should see the Vehicle Checker page') do
  expect(page).to have_current_path(enter_details_vehicle_checkers_path)
end

Then('I should enter a vehicle’s registration') do
  fill_in('vrn', with: 'CU57ABC')
end

Then('I should enter a vehicle’s registration with {string}') do |string|
  fill_in('vrn', with: string)
end

Then('I press the Continue') do
  click_button 'Continue'
end

Then('I should see the Confirm Details page') do
  expect(page).to have_current_path(confirm_details_vehicle_checkers_path, ignore_query: true)
end

Then('I choose that the details are correct') do
  choose('Yes')
end

Then('I choose that the details are incorrect') do
  choose('No')
end

Then('I press the Confirm') do
  click_button 'Confirm'
end

Then('I should see the Incorrect Details page') do
  expect(page).to have_current_path(incorrect_details_vehicle_checkers_path, ignore_query: true)
end

Then('I press the Search Again link') do
  click_link 'search again'
end
