class CreateFieldSets < ActiveRecord::Migration
  def change
    create_table :field_sets do |t|
      t.string :type
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
