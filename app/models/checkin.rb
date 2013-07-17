class Checkin < ActiveRecord::Base
  scope :unsynced, -> { where(synced_at: nil) }

  validates_presence_of :smartcard_id, :reader_id
  # , :location_key

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
