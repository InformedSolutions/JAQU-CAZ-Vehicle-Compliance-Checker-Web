# frozen_string_literal: true

module AddVrnToSession
  def add_vrn_to_session(vrn: 'CU57ABC')
    post validate_vrn_vehicle_checkers_path, params: { vrn: vrn }
  end
end
