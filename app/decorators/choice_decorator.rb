# coding: utf-8
module ChoiceDecorator

  def link_to_edit(choice_field)
    return name unless choice_field.edit_able?
    link_to name, edit_choice_path(self)
  end
end
