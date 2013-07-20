class FieldSet < ActiveRecord::Base

  class SubklassNotRecognized < StandardError ; end

  def self.by_name
    order('name')
  end

  def self.subklass(kind)
    return PersonFieldSet.new(type: 'PersonFieldSet') if kind == 'Person'
    raise SubklassNotRecognized
  end

  def self.subklass_with(params_white)
    return PersonFieldSet.new(params_white) if params_white[:type] == 'PersonFieldSet'
    raise SubklassNotRecognized
  end
end
