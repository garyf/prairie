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
    hsh = params_white.merge setup_p: true
    return CheckboxBooleanField.new(hsh) if params_white[:type] == 'CheckboxBooleanField'
    return RadioButtonField.new(hsh) if params_white[:type] == 'RadioButtonField'
    return SelectField.new(hsh) if params_white[:type] == 'SelectField'
    raise SubklassNotRecognized
  end

  def choice_row_edit_able?
    choices.count > 1
  end

  alias_method :enable_able?, :choice_row_edit_able?

  def edit_able?
    !parent? || choice_row_edit_able?
  end

  def enablement_confirm
    return unless enabled_p
    if choices.count == 2
      self.enabled_p = false
      self.save
    end
  end

  def instructions
    # optional, define in decorator
  end
end
