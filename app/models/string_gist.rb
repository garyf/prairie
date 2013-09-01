class StringGist < ActiveRecord::Base

  validates :custom_field_id, :parent_id, presence: true
  validates :gist, presence: true, length: 1..255

  def self.parent_ids_where_field_and_gist(custom_field_id, str)
    where(custom_field_id: custom_field_id, gist: str).pluck(:parent_id)
  end

  def self.where_field_and_parent(custom_field_id, parent_id)
    where(custom_field_id: custom_field_id, parent_id: parent_id)
  end
end
