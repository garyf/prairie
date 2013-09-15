class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.string :name, null: false
      t.string :description
      t.integer :row, null: false

      t.timestamps
    end
  end
end
