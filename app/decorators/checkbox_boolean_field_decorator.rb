# coding: utf-8
module CheckboxBooleanFieldDecorator

  def btn_to_cancel_choice
    link_to 'Cancel', setup_choice_field_path(self), class: 'btn'
  end

  def btn_to_cancel_field(field_set)
    return btn_to_cancel_choice if id
    link_to 'Cancel', field_set_path(field_set), class: 'btn'
  end

  def instructions
    render 'checkbox_boolean'
  end

  def link_to_edit
    link_to name, setup_choice_field_path(self) # /show allows editing of field choices
  end

  def link_to_value_edit(parent_id, value_str = nil)
    if value_str
      values = choices.name_pluck_by_row
      str = value_str == '1' ? values[0] : values[1]
    else
      str = 'checkbox, undefined'
    end
    link_to str, edit_checkbox_boolean_field_path(self, parent_id: parent_id), {id: "field_#{id}"}
  end

  def search_input
    check_box_tag "field_#{id}_gist"
  end
end
