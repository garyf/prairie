# coding: utf-8
module LocationFieldSetDecorator

  def name_with_type
    "#{name}, for locations"
  end

  def type_human
    'Locations'
  end

  def btn_to_cancel_field
    link_to 'Cancel', field_set_path(self), class: 'btn'
  end

  def btn_to_cancel_value_edit(parent_id)
    link_to 'Cancel', field_values_path(field_set_id: id, parent_id: parent_id), class: 'btn'
  end
end
