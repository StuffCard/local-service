class SyncController < ApplicationController
  skip_before_filter :verify_authenticity_token

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

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id, :location_key, :created_at)
  end
end
