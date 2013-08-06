class RadioButtonField < ChoiceField

  def choice_new_able?
    choices.count < 8
  end

  def type_human(downcase_p = false)
    str = 'Radio button field'
    downcase_p ? str.downcase : str
  end
end
