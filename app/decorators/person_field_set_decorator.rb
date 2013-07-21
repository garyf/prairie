# coding: utf-8
module PersonFieldSetDecorator

  def name_with_type
    "#{name}, for people"
  end

  def type_human
    'People'
  end

  def btn_to_cancel_field
    link_to 'Cancel', field_set_path(self), class: 'btn'
  end
end
