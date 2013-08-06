class CheckboxBooleanField < ChoiceField

  def choice_new_able?
    choices.count < 2
  end

  def type_human(downcase_p = false)
    str = 'Checkbox field'
    downcase_p ? str.downcase : str
  end
end
