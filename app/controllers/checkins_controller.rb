class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token, if: lambda { action_name == 'create' && request.remote_ip == '127.0.0.1'}

  def index
    location = Location.find_by_key(Rails.application.config.service.location_key)
    @checkins = location.absolute_numbers_for_today if location
  end

  def create
    # location = Location.find_or_create_slave_location
    checkin = Checkin.new(checkin_params)
    # checkin.location_key = location.key
    if checkin.save
      # WebsocketRails[:checkin].trigger :new_checkin, {checkins: location.absolute_numbers_for_today}
      head :created
    else
      head :bad_request
    end
  end

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id, :created_at)
    # params.require(:checkin).permit(:smartcard_id, :reader_id, :location_key, :created_at)
  end
end
