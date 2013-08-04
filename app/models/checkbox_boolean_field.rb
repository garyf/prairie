class CheckboxBooleanField < ChoiceField

  def choice_new_able?
    choices.count < 2
  end
end
