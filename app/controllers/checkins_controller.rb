class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token, if: lambda { action_name == 'create' && request.remote_ip == '127.0.0.1'}

  def index
    @checkins = Checkin.absolute_numbers_for_today
    @service_name = Rails.application.config.service.location[:name]
    @current_time = DateTime.now.beginning_of_hour.to_i * 1000
  end

  def create
    checkin = Checkin.new checkin_params
    checkin.location_key = Rails.application.config.service.location[:key]
    if checkin.save
      # trigger update of view
      if master_mode?
        WebsocketRails[:sync].trigger :new_sync, Location.absolute_numbers_for_today
      else
        WebsocketRails[Rails.application.config.service.location[:key]].trigger :new_checkin, {checkins: Checkin.absolute_numbers_for_today}
      end
      head :created
    else
      head :bad_request
    end
  end

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id)
  end
end
