# coding: utf-8
module NumericFieldDecorator

  def link_to_edit
    link_to name, edit_setup_numeric_field_path(self)
  end

  def link_to_value_edit(parent_id, value_str)
    value_str ||= 'numeric, undefined'
    link_to value_str, edit_numeric_field_path(self, parent_id: parent_id)
  end

  def search_input
    text_field_tag "field_#{id}_gist", nil, class: 'input-mini'
  end

  def only_integer?
    only_integer_p == '1' ? 'yes' : 'no'
  end

  def type_abrv
    'Numeric'
  end
end
