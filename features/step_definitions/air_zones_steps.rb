# frozen_string_literal: true

include MockHelpers

Then('I should see the CAZ selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path, ignore_query: true)
end

Then('I choose the caz zone') do
  check('caz-1')
end

Then('I should see the Compliance page') do
  expect(page).to have_current_path(compliance_air_zones_path, ignore_query: true)
end

Then('I press the Continue on CAZ selection page') do
  mock_vehicle_compliance
  click_button 'Continue'
end
