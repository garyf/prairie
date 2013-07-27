# coding: utf-8
module SelectFieldDecorator

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def type_human
    'Select list field'
  end

  def type_abrv
    'Select'
  end
end
