class Checkin < ActiveRecord::Base
  scope :unsynced, -> { where(synced_at: nil) }

  after_create :sync_with_master, :unless => Proc.new{ Rails.application.config.service.type == :master }

  validates_presence_of :smartcard_id, :reader_id

  def self.absolute_numbers_for_today
    # Every hour for the past 12 hours
    start_time = DateTime.now.beginning_of_hour - 12.hours
    end_time = DateTime.now.beginning_of_hour + 1.hour
    time_slots = {}

    while start_time <= end_time do
      time_slots[start_time] = self.where(created_at: [(start_time)..(start_time + 1.hour)], location_key: Rails.application.config.service.location[:key].to_sym).count
      start_time = start_time + 1.hour
    end

    result = []
    time_slots.each{ |k,v| result << [k.to_i, v] }
    result
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
end
