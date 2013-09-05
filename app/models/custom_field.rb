class CustomField < ActiveRecord::Base

  include RankedModel
  include Redis::Objects
  include RedisCustomFields

  belongs_to :field_set
  has_many :choices, dependent: :destroy

  after_save :fields_enabled_count
  after_destroy :fields_enabled_count

  ranks :row, class_name: 'CustomField', with_same: :field_set_id # https://github.com/mixonic/ranked-model/pull/28

  paginates_per 8

  validates :field_set, :type, presence: true
  validates :name, presence: true, uniqueness: {scope: :field_set}

  attr_accessor :gist, :parent_id

  delegate :parent, to: :field_set

  def self.by_row
    order('row')
  end

  def self.enabled
    where(enabled_p: true)
  end

  def self.enabled_by_row_page(page)
    enabled.by_row.page page
  end

  def self.ranked_page(page)
    rank(:row).page page
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    field_set.custom_fields.position_above_count(row) + 1
  end

private

  def fields_enabled_count
    field_set.fields_enabled_count
  end
end
