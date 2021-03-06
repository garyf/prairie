# coding: utf-8
module NumericFieldDecorator

  def link_to_edit
    link_to name, edit_setup_numeric_field_path(self)
  end

  def link_to_value_edit(parent_id, value_str = nil)
    value_str ||= 'numeric, undefined'
    link_to value_str, edit_numeric_field_path(self, parent_id: parent_id), {id: "field_#{id}"}
  end

  def search_input
    text_field_tag "field_#{id}_nbr_gist", nil, class: 'input-mini'
  end

  def only_integer?
    only_integer_p == '1' ? 'Yes' : 'No'
  end

  def type_human(downcase_p = false)
    str = 'Numeric field'
    downcase_p ? str.downcase : str
  end
end
