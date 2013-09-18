class NumericGist < ActiveRecord::Base

  belongs_to :numeric_field, foreign_key: :custom_field_id

  validates :custom_field_id, :parent_id, presence: true
  validates :gist, numericality: true

  # these three queries are usable only via the numeric_field :numeric_gists association
  # otherwise, several numeric fields might have gists that match the value

  def self.parent_id_where_numeric_range(value)
    where(gist: Search::value_range_near(value)).pluck(:parent_id)
  end

  def self.parent_id_where_gist(nbr)
    where(gist: nbr).pluck(:parent_id)
  end

  def self.where_parent_id(int)
    where(parent_id: int)
  end
end
