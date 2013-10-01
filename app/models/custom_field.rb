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

  validates :enabled_p, :required_p, inclusion: {in: [true, false], message: 'must be true or false'}
  validates :field_set, :type, presence: true
  validates :name, presence: true, uniqueness: {scope: :field_set}
  validate :gist_required_present

  attr_accessor :gist, :parent_id, :setup_p

  delegate :fields_enabled_count, :parent, to: :field_set

  class GistDuplicate < StandardError ; end

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

  def self.required_any?
    where(required_p: true).any?
  end

  # active_decorator does not support single table inheritance
  def disabled_state
    'Disabled' unless enabled_p
  end

  def human_row
    field_set.custom_fields.position_above_count(row) + 1
  end

private

  def gist_required_present
    return if setup_p
    errors.add(:gist, "of a required field can't be blank") if required_p && gist.blank?
  end

  def postgres_index_on_gist_update(relation, gist_for_index)
    raise GistDuplicate if relation.count > 1
    o = relation[0]
    return unless o
    o.update gist: gist_for_index
  end

  def validate_min_lte_max(attribute, max, min, str)
    return if max.blank? || min.blank?
    errors.add(attribute, "must be less than or equal to #{max} (#{str} max)") if min.to_i > max.to_i
  end
end
