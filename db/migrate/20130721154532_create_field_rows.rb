class CreateFieldRows < ActiveRecord::Migration
  def change
    create_table :field_rows do |t|
      t.references :custom_field, index: true
      t.references :field_set, index: true
      t.integer :row

      t.timestamps
    end
  end
end
