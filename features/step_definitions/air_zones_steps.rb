# frozen_string_literal: true

Then('I should see the CAZ selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path, ignore_query: true)
end
