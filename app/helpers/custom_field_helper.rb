module CustomFieldHelper

  def inline_help(str)
    "<span class=help-inline>#{str}</span>".html_safe
  end

  def required_star(custom_field)
    inline_help('*') if custom_field.required_p
  end

  def required_field(custom_field)
    inline_help('<i>Required field</i>') if custom_field.required_p
  end
end
