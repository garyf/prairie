class CreateNumericGists < ActiveRecord::Migration
  def change
    create_table :numeric_gists do |t|
      t.string :type, null: false
      t.references :custom_field, null: false, index: true
      t.float :gist, null: false
      t.integer :parent_id, null: false
    end
  end
end
