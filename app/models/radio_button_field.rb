class RadioButtonField < ChoiceField

  def choice_new_able?
    choices.count < 8
  end
end
