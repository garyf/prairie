class FieldRow < ActiveRecord::Base

  include RankedModel

  belongs_to :custom_field
  belongs_to :field_set

  ranks :row, with_same: 'field_set_id'

  paginates_per 8

  validates :custom_field, :field_set, presence: true

  def self.ranked_page(page)
    rank(:row).page page
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    field_set.field_rows.position_above_count(row) + 1
  end
end
