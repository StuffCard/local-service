class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name,   limit: 255
      t.string :key,    limit: 255
      t.string :slug,   limit: 8

      t.timestamps
    end
  end
end
