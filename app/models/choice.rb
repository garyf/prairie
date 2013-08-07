class Choice < ActiveRecord::Base

  include RankedModel

  belongs_to :custom_field

  validates :custom_field, presence: true
  validates :name, presence: true, uniqueness: {scope: :custom_field}

  ranks :row, with_same: :custom_field_id

  def self.name_by_row
    select(:name).order('row')
  end

  def self.name_ranked
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

  def parents
    custom_field.parents_find_by_gist(name) unless name.blank?
  end

  def parents?
    parents.count > 0 if parents
  end

  def name_edit_able?
    !parents?
  end
end
