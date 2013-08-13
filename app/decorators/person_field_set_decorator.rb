# coding: utf-8
module PersonFieldSetDecorator

  def btn_to_cancel_field
    link_to 'Cancel', field_set_path(self), class: 'btn'
  end

  def btn_to_cancel_value_edit(parent_id)
    link_to 'Cancel', field_values_path(field_set_id: id, parent_id: parent_id), class: 'btn'
  end

  def kind(downcase_p = false)
    str = 'Person'
    downcase_p ? str.downcase : str
  end

  def name_with_kind
    "#{name} (#{kind true})"
  end

  def type_human(downcase_p = false)
    str = 'People'
    downcase_p ? str.downcase : str
  end
end
