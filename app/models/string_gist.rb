class StringGist < ActiveRecord::Base

  belongs_to :string_field, foreign_key: :custom_field_id

  validates :custom_field_id, :parent_id, presence: true
  validates :gist, presence: true, length: 1..255

  # these three queries are usable only via the string_fields :string_gists association
  # otherwise, several string fields might have gists that match the value

  def self.parent_id_where_ILIKE_gist(str)
    where(StringGist.arel_table[:gist].matches "%#{str}%").pluck(:parent_id)
  end

  def self.parent_id_where_gist(str)
    where(gist: str).pluck(:parent_id)
  end

  def self.where_parent_id(int)
    where(parent_id: int)
  end
end
