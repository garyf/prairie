class CustomField < ActiveRecord::Base

  include Redis::Objects
  include RedisCustomFields

  belongs_to :field_set
  has_one :field_row, dependent: :destroy

  def field_row_create(field_set_id)
    o = FieldRow.new(
      custom_field_id: id,
      field_set_id: field_set_id,
      row_position: :last)
    o.save
  end
end
