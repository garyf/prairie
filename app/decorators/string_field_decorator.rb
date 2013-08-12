# coding: utf-8
module StringFieldDecorator

  def link_to_edit
    link_to name, edit_setup_string_field_path(self)
  end

  def link_to_value_edit(parent_id, value_str = nil)
    value_str ||= 'string, undefined'
    link_to value_str, edit_string_field_path(self, parent_id: parent_id), {id: "field_#{id}"}
  end

  def search_input
    text_field_tag "field_#{id}_gist", nil, class: 'input-mini'
  end

  def type_human(downcase_p = false)
    str = 'String field'
    downcase_p ? str.downcase : str
  end
end
