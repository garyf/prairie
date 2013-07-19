class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :email, null: false
      t.string :name_first
      t.string :name_last, null: false

      t.timestamps
    end
  end
end
