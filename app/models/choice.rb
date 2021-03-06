class Choice < ActiveRecord::Base

  include RankedModel

  belongs_to :custom_field

  ranks :row, with_same: :custom_field_id

  validates :custom_field, presence: true
  validates :name, presence: true, uniqueness: {scope: :custom_field}

  def self.name_by_row
    select(:name).order('row')
  end

  def self.name_pluck_by_row
    order(:row).pluck(:name)
  end

  def self.ranked_page(page)
    rank(:row).page page
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    custom_field.choices.position_above_count(row) + 1
  end

  def destroyable?
    !parents?
  end

  alias_method :name_edit_able?, :destroyable?

  def choice_field_enablement_confirm_and_self_destroy
    return unless destroyable?
    custom_field.enablement_confirm
    self.destroy
  end

  def parents
    custom_field.parents_find_by_gist(name) unless name.blank?
  end

  def parents?
    parents.count > 0 if parents
  end
end
