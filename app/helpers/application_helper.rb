module ApplicationHelper

  def nav_active(controller_str)
    'class=active' if params[:controller] == controller_str
  end
end
