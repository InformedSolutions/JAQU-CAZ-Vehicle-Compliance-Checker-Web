# frozen_string_literal: true

module AddVrnToSession
  def add_vrn_to_session(vrn: 'CU57ABC', country: 'UK')
    post enter_details_vehicle_checkers_path, params: { vrn: vrn, 'registration-country': country }
  end
end
