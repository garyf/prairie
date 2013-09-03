class StringGist < ActiveRecord::Base

  belongs_to :string_field, foreign_key: :custom_field_id

  validates :custom_field_id, :parent_id, presence: true
  validates :gist, presence: true, length: 1..255

  # usable only via the string_fields :custom_fields association
  # otherwise, several string fields might have gists that match the value
  def self.id_where_ILIKE_value(value)
    where(StringGist.arel_table[:gist].matches "%#{value}%").pluck(:parent_id)
  end

  def self.parent_ids_where_field_and_gist(custom_field_id, str)
    where(custom_field_id: custom_field_id, gist: str).pluck(:parent_id)
  end

  def self.where_field_and_parent(custom_field_id, parent_id)
    where(custom_field_id: custom_field_id, parent_id: parent_id)
  end
end
