module ApplicationHelper

  def nav_active(controller_str)
    'class=active' if params[:controller] == controller_str
  end

  def search_results_count
    t('helpers.search_results.count', count: @results_count || 0)
  end

  def last_search_page?(page, per_page)
    page >= (@results_count.to_f / per_page).ceil
  end

  def search_results_info
    entry_name = params[:controller].split('_')[0]
    entry_name = entry_name.pluralize unless @results_count == 1
    per_page = Search::RESULTS_PER_PAGE
    if @results_count < per_page + 1
      t('helpers.search_results.single_page',
        entry_name: entry_name,
        count: @results_count)
    else
      page = params[:page].to_i
      page_offset = (page - 1) * per_page
      t('helpers.search_results.multiple_pages',
        entry_name: entry_name.capitalize,
        first: page_offset + 1,
        last: last_search_page?(page, per_page) ? @results_count : page_offset + per_page)
    end.html_safe
  end
end
