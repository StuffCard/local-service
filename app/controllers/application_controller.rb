class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def master_mode?
    return Rails.application.config.service.type == :master
  end

  def slave_mode?
    return Rails.application.config.service.type == :slave
  end
end
