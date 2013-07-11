class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.string      :smartcard_id
      t.string      :reader_id
      t.string      :location_key,  limit: 255
      t.datetime    :synced_at,     default: nil

      t.timestamps
    end
  end
end
