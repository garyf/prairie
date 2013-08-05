# coding: utf-8
module LocationFieldSetDecorator

  def btn_to_cancel_field
    link_to 'Cancel', field_set_path(self), class: 'btn'
  end

  def btn_to_cancel_value_edit(parent_id)
    link_to 'Cancel', field_values_path(field_set_id: id, parent_id: parent_id), class: 'btn'
  end

  def name_with_type
    "#{name}, for locations"
  end

  def type_human(downcase_p = false)
    str = 'Locations'
    downcase_p ? str.downcase : str
  end
end
