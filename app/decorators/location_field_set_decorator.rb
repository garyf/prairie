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
end
