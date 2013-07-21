# coding: utf-8
module StringFieldDecorator

  def link_to_edit
    link_to name, edit_setup_string_field_path(self)
  end

  def type_abrv
    'String'
  end
end
