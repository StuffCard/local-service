class Checkin < ActiveRecord::Base
  scope :unsynced, -> { where(synced_at: nil) }

  validates_presence_of :smartcard_id, :reader_id

  def self.absolute_numbers_for_today
    start_time = Date.today.to_time + 9.hours # 9 Uhr morgens
    end_time = Time.now + (59-Time.now.min).minutes # Nächste volle Stunde
    time_slots = {} # Jede Stunde zwischen 9 Uhr und jetzt
    while start_time < end_time do
      time_slots[start_time] = self.where(created_at: [(start_time)..(start_time + 1.hour)]).count
      start_time = start_time + 1.hour
    end
    result = []
    time_slots.each{ |k,v| result << [k.hour, v] }
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
    response = HTTParty.post("#{Rails.application.config.service.master_url}/checkins", data)
    if response.created?
      self.update_attribute :synced_at, Time.now
    end
  end
end
