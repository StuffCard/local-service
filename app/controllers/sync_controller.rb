class SyncController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_origin

  def create
    if Checkin.where(smartcard_id: checkin_params[:smartcard_id], reader_id: checkin_params[:reader_id], location_key: checkin_params[:location_key], created_at: checkin_params[:created_at]).exists?
        head :created
      else
        checkin = Checkin.new checkin_params
        checkin.synced_at = Time.now
        if checkin.save
          WebsocketRails[:sync].trigger :new_sync, Location.absolute_numbers_for_today
          head :created
        else
          head :bad_request
        end
      end
  end

  protected

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id, :location_key, :created_at)
  end

  def check_origin
    # Check if origin IP is the one we'd expect it to be
    head :bad_request unless request.remote_ip == Rails.application.config.service.master.ips[checkin_params[:location_key]]
  end
end
