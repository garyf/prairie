class SelectField < ChoiceField

  def choice_new_able?
    choices.count < 55
  end

  def type_human(downcase_p = false)
    str = 'Select list field'
    downcase_p ? str.downcase : str
  end
end
