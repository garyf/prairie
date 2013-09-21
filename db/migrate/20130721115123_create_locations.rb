class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.references :county, index: true
      t.string :description
      t.integer :elevation_feet
      t.float :lot_acres
      t.boolean :public_p, null: false

      t.timestamps
    end
  end
end
