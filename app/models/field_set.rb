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

  def self.enabled_by_name
    where('fields_enabled_qty > 0').by_name
  end

  # each subklass may have 12 records
  def self.new_able?
    self.count < 13
  end

  def new_able?
    self.class.new_able?
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

  def fields_enabled_count
    int = custom_fields.enabled.count
    return if int == fields_enabled_qty
    self.fields_enabled_qty = int
    self.save
  end
end
