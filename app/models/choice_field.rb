class ChoiceField < CustomField

  class SubklassNotRecognized < StandardError ; end

  def self.subklass(kind, field_set_id)
    return CheckboxBooleanField.new(type: 'CheckboxBooleanField', field_set_id: field_set_id) if kind == 'Checkbox'
    return RadioButtonField.new(type: 'RadioButtonField', field_set_id: field_set_id) if kind == 'Radio'
    return SelectField.new(type: 'SelectField', field_set_id: field_set_id) if kind == 'Select'
    raise SubklassNotRecognized
  end

  def self.subklass_with(params_white)
    return CheckboxBooleanField.new(params_white) if params_white[:type] == 'CheckboxBooleanField'
    return RadioButtonField.new(params_white) if params_white[:type] == 'RadioButtonField'
    return SelectField.new(params_white) if params_white[:type] == 'SelectField'
    raise SubklassNotRecognized
  end

  def choice_row_edit_able?
    choices.count > 1
  end

  def instructions
    # optional, implemented in decorator
  end
end
