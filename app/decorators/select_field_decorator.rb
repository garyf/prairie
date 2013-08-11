# coding: utf-8
module SelectFieldDecorator

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def btn_to_cancel_field(field_set)
    return btn_to_cancel_choice if id
    link_to 'Cancel', field_set_path(field_set), class: 'btn'
  end

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str = nil)
    value_str ||= 'select list, undefined'
    link_to value_str, edit_select_field_path(self, parent_id: parent_id)
  end

  def search_input
    values = choices.name_pluck_by_row
    select_tag "field_#{id}_gist", options_for_select(values), prompt: 'Please select'
  end
end
