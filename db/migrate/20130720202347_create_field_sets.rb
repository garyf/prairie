class CreateFieldSets < ActiveRecord::Migration
  def change
    create_table :field_sets do |t|
      t.string :type, null: false
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
