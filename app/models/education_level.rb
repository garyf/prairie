class EducationLevel < ActiveRecord::Base

  include RankedModel

  has_many :people

  validates :name, presence: true, uniqueness: true

  ranks :row

  def self.by_row
    order('row')
  end

  def self.name_by_row
    select(:name).order('row')
  end

  def self.row_edit_able?
    EducationLevel.count > 1
  end

  def destroyable?
    people.count == 0
  end

  def self.position_above_count(row)
    where('row < ?', row).count
  end

  def human_row
    EducationLevel.position_above_count(row) + 1
  end
end
