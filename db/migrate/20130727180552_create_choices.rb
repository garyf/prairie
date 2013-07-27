class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string :name
      t.references :custom_field, index: true
      t.integer :row

      t.timestamps
    end
  end
end
