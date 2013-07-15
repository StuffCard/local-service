class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def index

  end

  def create
    checkin = Checkin.new(checkin_params)
    checkin.location_key = Rails.application.config.service.location_key if slave_mode?
    if checkin.save
      head :created
    else
      head :bad_request
    end
  end

  def checkin_params
    params.require(:checkin).permit(:smartcard_id, :reader_id, :location_key)
  end
end
