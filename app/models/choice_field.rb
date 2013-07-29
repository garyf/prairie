class ChoiceField < CustomField

  class SubklassNotRecognized < StandardError ; end

  def self.subklass(kind, field_set_id)
    return RadioButtonField.new(type: 'RadioButtonField', field_set_id: field_set_id) if kind == 'Radio'
    return SelectField.new(type: 'SelectField', field_set_id: field_set_id) if kind == 'Select'
    raise SubklassNotRecognized
  end

  def self.subklass_with(params_white)
    return RadioButtonField.new(params_white) if params_white[:type] == 'RadioButtonField'
    return SelectField.new(params_white) if params_white[:type] == 'SelectField'
    raise SubklassNotRecognized
  end
end
