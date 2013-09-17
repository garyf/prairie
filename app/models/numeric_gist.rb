class NumericGist < ActiveRecord::Base

  belongs_to :numeric_field, foreign_key: :custom_field_id

  validates :custom_field_id, :parent_id, presence: true
  validates :gist, numericality: true

end