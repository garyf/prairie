class FieldSet < ActiveRecord::Base

  has_many :custom_fields, dependent: :destroy
  has_many :numeric_fields, dependent: :destroy
  has_many :string_fields, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true

  class SubklassNotRecognized < StandardError ; end

  def self.by_name
    order('name')
  end

  # each subklass may have 12 records
  def self.new_able?
    self.count < 13
  end

  def self.subklass(kind)
    return LocationFieldSet.new(type: 'LocationFieldSet') if kind == 'Location'
    return PersonFieldSet.new(type: 'PersonFieldSet') if kind == 'Person'
    raise SubklassNotRecognized
  end

  def self.subklass_with(params_white)
    return LocationFieldSet.new(params_white) if params_white[:type] == 'LocationFieldSet'
    return PersonFieldSet.new(params_white) if params_white[:type] == 'PersonFieldSet'
    raise SubklassNotRecognized
  end

  def destroyable?
    custom_fields.count == 0
  end

  def custom_field_new_able?
    custom_fields.count < 21
  end

  def custom_field_row_edit_able?
    custom_fields.count > 1
  end
end
