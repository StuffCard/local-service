class Location < ActiveRecord::Base

    before_validation :generate_key

    validates :name,    presence: true
    validates :key,     presence: true, uniqueness: true
    validates :slug,    presence: true, allow_nil: true

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
