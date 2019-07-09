# frozen_string_literal: true

Then('I should see the CAZ selection page') do
  expect(page).to have_current_path(caz_selection_air_zones_path, ignore_query: true)
end

Then('I get a caz zones') do
  caz_list_response = File.read('spec/fixtures/files/caz_list_response.json')
  WebMock::API.stub_request(:get, /clean_air_zones/).to_return(
    body: caz_list_response,
    headers: { 'Content-Type' => 'application/json' }
  )
end

Then('I choose the caz zone') do
  check('caz-1')
end

Then('I should see the Compliance page') do
  expect(page).to have_current_path(compliance_air_zones_path, ignore_query: true)
end
