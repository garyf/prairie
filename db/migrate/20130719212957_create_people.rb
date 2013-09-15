class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :email, null: false
      t.string :name_first
      t.string :name_last, null: false
      t.integer :birth_year
      t.references :education_level, index: true
      t.float :height
      t.boolean :male_p, null: false

      t.timestamps
    end
  end
end
