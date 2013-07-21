class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :type, null: false
      t.references :field_set, null: false, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
