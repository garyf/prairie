class Choice < ActiveRecord::Base

  include RankedModel

  belongs_to :custom_field

  validates :custom_field, presence: true
  validates :name, presence: true, uniqueness: {scope: :custom_field}

  ranks :row, with_same: :custom_field_id

  def self.ranked_page(page)
    rank(:row).page page
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    custom_field.choices.position_above_count(row) + 1
  end
end
