class SelectField < ChoiceField

  def choice_new_able?
    choices.count < 55
  end
end
