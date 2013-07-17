class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token, if: lambda { action_name == 'create' && (request.remote_ip == '127.0.0.1' || master_mode?)}

  def index
    if slave_mode?
      location = Location.find_by_key(Rails.application.config.service.location_key)
      @checkins = location.absolute_numbers_for_today if location
    end
  end

  def create
    if slave_mode?
      location = Location.find_or_create_slave_location
      checkin = Checkin.new(checkin_params)
      checkin.location_key = location.key
      if checkin.save
        WebsocketRails[:checkin].trigger :new_checkin, {checkins: location.absolute_numbers_for_today}
        head :created
      else
        head :bad_request
      end
    end
    if master_mode?
      if Checkin.where(smartcard_id: checkin_params[:smartcard_id], reader_id: checkin_params[:reader_id], location_key: checkin_params[:location_key], created_at: checkin_params[:created_at]).exists?
        head :created
      else
        checkin = Checkin.new(checkin_params)
        checkin.synced_at = Time.now
        if checkin.save
          WebsocketRails[:checkin].trigger :new_checkin, {checkins: location.absolute_numbers_for_today}
          head :created
        else
          head :bad_request
        end
      end
    end
  end

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id, :location_key, :created_at)
  end
end
