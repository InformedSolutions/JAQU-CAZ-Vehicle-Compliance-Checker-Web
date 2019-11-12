# frozen_string_literal: true

include MockHelpers

Then('I choose Leeds') do
  mock_vehicle_compliance
  check('Leeds')
end

Then('I press Check another vehicle') do
  click_link('Check another vehicle')
end
