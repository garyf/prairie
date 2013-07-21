class CreateFieldRows < ActiveRecord::Migration
  def change
    create_table :field_rows do |t|
      t.references :custom_field, null: false, index: true
      t.references :field_set, null: false, index: true
      t.integer :row, null: false

      t.timestamps
    end
  end
end
