# coding: utf-8
module SelectFieldDecorator

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str = nil)
    value_str ||= 'select list, undefined'
    link_to value_str, edit_select_field_path(self, parent_id: parent_id)
  end

  def search_input
    values = choices.name_ranked
    select_tag "field_#{id}_gist", options_for_select(values), prompt: 'Please select'
  end

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def type_human
    'Select list field'
  end

  def type_abrv
    'Select list'
  end
end
