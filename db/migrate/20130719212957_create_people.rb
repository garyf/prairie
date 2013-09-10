class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :email, null: false
      t.string :name_first
      t.string :name_last, null: false
      t.integer :birth_year
      t.float :height

      t.timestamps
    end
  end
end
