class CustomField < ActiveRecord::Base

  include Redis::Objects
  include RedisCustomFields

  belongs_to :field_set
  has_one :field_row, dependent: :destroy

  validates :field_set, presence: true
  validates :name, presence: true, uniqueness: {scope: :field_set}
  validates :type, presence: true

  attr_accessor :gist, :parent_id

  delegate :parent, to: :field_set

  def field_row_create(field_set_id)
    o = FieldRow.new(
      custom_field_id: id,
      field_set_id: field_set_id,
      row_position: :last)
    o.save
  end
end
