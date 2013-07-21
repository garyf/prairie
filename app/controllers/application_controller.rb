class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private

  # display 1-indexed row_position; gem ranked-model is 0-indexed
  def params_white_w_human_row(hsh = params_white)
    str = hsh['row_position']
    return hsh if str.blank?
    hsh['row_position'] = (str.to_i - 1).to_s
    hsh
  end

  # display paginated row index == human_row
  def paginate_row_offset_assign(per_page = 8)
    @row_offset = params[:page] ? 1 + (params[:page].to_i - 1) * per_page : 1
  end
end
