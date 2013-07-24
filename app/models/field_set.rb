class FieldSet < ActiveRecord::Base

  has_many :custom_fields
  has_many :field_rows, dependent: :destroy
  has_many :string_fields, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true

  class SubklassNotRecognized < StandardError ; end

  def self.by_name
    order('name')
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

  def field_row_editable?
    custom_fields.count > 1
  end
end
