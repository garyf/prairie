class CreateEducationLevels < ActiveRecord::Migration
  def change
    create_table :education_levels do |t|
      t.string :name
      t.string :description
      t.integer :row

      t.timestamps
    end
  end
end
