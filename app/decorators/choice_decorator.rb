# coding: utf-8
module ChoiceDecorator

  def link_to_edit
    link_to name, edit_choice_path(self)
  end
end
