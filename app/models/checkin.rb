class Checkin < ActiveRecord::Base
  validates_presence_of :smartcard_id, :reader_id, :location_key
end
