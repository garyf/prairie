class CreateStringGists < ActiveRecord::Migration
  def change
    create_table :string_gists do |t|
      t.references :custom_field, null: false, index: true
      t.string :gist, null: false
      t.integer :parent_id, null: false
    end
  end
end
