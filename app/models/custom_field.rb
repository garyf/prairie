class CustomField < ActiveRecord::Base

  include RankedModel
  include Redis::Objects
  include RedisCustomFields

  belongs_to :field_set
  has_many :choices, dependent: :destroy

  ranks :row, class_name: 'CustomField', with_same: :field_set_id # https://github.com/mixonic/ranked-model/pull/28

  paginates_per 8

  validates :field_set, :type, presence: true
  validates :name, presence: true, uniqueness: {scope: :field_set}

  attr_accessor :gist, :parent_id

  delegate :parent, to: :field_set

  def self.ranked_page(page)
    rank(:row).page page
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    field_set.custom_fields.position_above_count(row) + 1
  end
end
