# frozen_string_literal: true

Then('I should see the CAZ selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path, ignore_query: true)
end

Then('I choose the caz zone') do
  mock_vehicle_compliance
  check('caz-1')
end

Then('I should see the Compliance page') do
  expect(page).to have_current_path(compliance_air_zones_path, ignore_query: true)
end
