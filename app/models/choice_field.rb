class ChoiceField < CustomField

  class SubklassNotRecognized < StandardError ; end

  def self.subklass(kind, field_set_id)
    hsh = {field_set_id: field_set_id, enabled_p: false} # enabled_p true requires > 1 choice
    return CheckboxBooleanField.new({type: 'CheckboxBooleanField'}.merge hsh) if kind == 'Checkbox'
    return RadioButtonField.new({type: 'RadioButtonField'}.merge hsh) if kind == 'Radio'
    return SelectField.new({type: 'SelectField'}.merge hsh) if kind == 'Select'
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

  alias_method :enable_able?, :choice_row_edit_able?

  def edit_able?
    !parent? || choice_row_edit_able?
  end

  def instructions
    # optional, define in decorator
  end
end
