class Checkin < ActiveRecord::Base
  scope :unsynced, where(synced_at: nil)
  scope :by_time_and_location, ->(time, location) {
    where(created_at: [(time)..(time + 1.hour)], location_key: location).count
  }

  after_create :sync_with_master, :unless => Proc.new{ Rails.application.config.service.type == :master }

  validates_presence_of :smartcard_id, :reader_id

  def self.absolute_numbers_for_today
    # Every hour for the past 12 hours
    start_time = 12.hours.ago.beginning_of_hour
    end_time = 1.hour.since.beginning_of_hour
    location = Rails.application.config.service.location[:key].to_sym

    steps_between(start_time, end_time).map do |time|
      [time.to_i, by_time_and_location(time, location)]
    end
  end

  def sync_with_master
    data = {
      body: {
        checkin: {
          smartcard_id: smartcard_id,
          reader_id: reader_id,
          location_key: location_key,
          created_at: created_at_before_type_cast
        }
      }
    }
    response = HTTParty.post("#{Rails.application.config.service.master[:sync]}", data)
    if response.created?
      self.update_attribute :synced_at, Time.now
    else
      # mark as failed so it will be retried
      raise error
    end
  end
  handle_asynchronously :sync_with_master


  private

  def self.steps_between(start_time, end_time, step = 1.hour)
    (start_time.to_i..end_time.to_i).step(1.hour).to_a.map{ |time| Time.at(time) }
  end
end
