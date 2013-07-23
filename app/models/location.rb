class Location < ActiveRecord::Base
  before_validation :generate_key

  validates :name,    presence: true
  validates :key,     presence: true, uniqueness: true

  has_many :checkins, primary_key: 'key', foreign_key: 'location_key'

  def self.absolute_numbers_for_today
    end_time = Time.now + (59-Time.now.min).minutes # Nächste volle Stunde
    time_slots = {} # Jede Stunde zwischen 7 Uhr und jetzt

    self.all.each do |location|
      start_time = Date.today.to_time + 7.hours # 7 Uhr morgens
      while start_time < end_time do
        # init empty hash
        time_slots[location.name] = {} unless time_slots[location.name].is_a? Hash

        time_slots[location.name][start_time] = location.checkins.where(created_at: [(start_time)..(start_time + 1.hour)]).count
        start_time = start_time + 1.hour
      end
    end

    result = {}
    time_slots.each do |location_name, checkin|
      result[location_name] = [] # init array
      checkin.each{ |k, v| result[location_name] << [k.hour, v] }
    end

    Rails.logger.debug result.inspect

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
