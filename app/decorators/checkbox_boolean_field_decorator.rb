# coding: utf-8
module CheckboxBooleanFieldDecorator

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str)
    ary = choices.order(:row)
    if value_str
      str = value_str == '1' ? ary[0].name : ary[1].name
    else
      str = 'checkbox, undefined'
    end
    link_to str, edit_checkbox_boolean_field_path(self, parent_id: parent_id)
  end

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def type_human
    'Checkbox field'
  end

  def type_abrv
    'Checkbox'
  end

  def instructions
    render 'checkbox_boolean'
  end
end
