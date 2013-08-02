# coding: utf-8
module RadioButtonFieldDecorator

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str)
    value_str ||= 'radio button, undefined'
    link_to value_str, edit_radio_button_field_path(self, parent_id: parent_id)
  end

  def search_input
    text_field_tag "field_#{id}_gist", nil, class: 'input-mini'
  end

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def type_human
    'Radio button field'
  end

  def type_abrv
    'Radio button'
  end
end
