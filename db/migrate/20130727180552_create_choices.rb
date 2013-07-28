class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :name, null: false
      t.references :custom_field, null: false, index: true
      t.integer :row, null: false

      t.timestamps
    end
  end
end
