# coding: utf-8
module RadioButtonFieldDecorator

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def btn_to_cancel_field(field_set)
    return btn_to_cancel_choice if id
    link_to 'Cancel', field_set_path(field_set), class: 'btn'
  end

  def enabled?
    enabled_p == true ? 'Yes' : 'No'
  end

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str = nil)
    value_str ||= 'radio button, undefined'
    link_to value_str, edit_radio_button_field_path(self, parent_id: parent_id), {id: "field_#{id}"}
  end

  def search_input
    values = choices.name_pluck_by_row
    str = ''
    values.each { |v| str << "<label class='radio'>#{radio_button_tag("field_#{id}_gist", v)}#{v}</label>" }
    str.html_safe
  end
end
