class Location < ActiveRecord::Base
  before_validation :generate_key

  validates :name,    presence: true
  validates :key,     presence: true, uniqueness: true
  validates :slug,    presence: true, allow_nil: true

  has_many :checkins, primary_key: 'key', foreign_key: 'location_key'

  def self.find_or_create_slave_location
    location = Location.find_or_create_by_key(Rails.application.config.service.location_key)
    location.name = Rails.application.config.service.location_name
    location.slug = Rails.application.config.service.location_slug
    if location.save
      location
    end
  end

  def absolute_numbers_for_today
    start_time = Date.today.to_time + 9.hours # 9 Uhr morgens
    end_time = Time.now + (59-Time.now.min).minutes # Nächste volle Stunde
    time_slots = {} # Jede Stunde zwischen 9 Uhr und jetzt
    while start_time < end_time do
      time_slots[start_time] = self.checkins.where(created_at: [(start_time)..(start_time + 1.hour)]).count
      start_time = start_time + 1.hour
    end
    result = []
    time_slots.each{ |k,v| result << [k.hour, v] }
    result
  end

  protected

  def generate_key
    hash =  [('a'..'z'),('A'..'Z'),(0..9)].map{|i| i.to_a}.flatten
    while self.key.nil?
      key  =  (0...40).map{ hash[rand(hash.length)] }.join
      if Location.where(key: key).count == 0
        self.key = key
      end
    end
  end
end
