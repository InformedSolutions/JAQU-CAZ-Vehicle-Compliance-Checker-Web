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

Then('I press the Continue') do
  click_link 'Continue'
end

Then('I should see the Confirm Details page') do
  # TO DO: uncomment when `confirm_details` will be implemented
  # expect(page).to have_current_path(confirm_details_vehicle_checkers_path)
end
