class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :email
      t.string :name_first
      t.string :name_last

      t.timestamps
    end
  end
end
