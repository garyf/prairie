class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :type, null: false
      t.references :field_set, null: false, index: true
      t.string :name, null: false
      t.integer :row, null: false
      t.boolean :enabled_p, null: false, default: true
      t.boolean :required_p, null: false, default: false

      t.timestamps
    end
  end
end
