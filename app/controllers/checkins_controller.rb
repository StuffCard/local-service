class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token, if: lambda { action_name == 'create' && request.remote_ip == '127.0.0.1'}

  def index
    @checkins = Checkin.absolute_numbers_for_today
  end

  def create
    checkin = Checkin.new checkin_params
    checkin.location_key = Rails.application.config.service.location[:key]
    if checkin.save
      # trigger update of view
      # WebsocketRails[Rails.application.config.service.location[:key]].trigger :new_checkin, {checkins: location.absolute_numbers_for_today}
      head :created
    else
      head :bad_request
    end
  end

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id)
  end
end
