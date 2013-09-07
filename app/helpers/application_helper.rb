module ApplicationHelper

  def nav_active(controller_str)
    'class=active' if params[:controller] == controller_str
  end

  def search_results_info(count_total)
    entry_name = params[:controller].split('_')[0]
    entry_name = entry_name.pluralize unless count_total == 1
    per_page = Search::RESULTS_PER_PAGE
    if count_total < per_page + 1
      t('helpers.search_results.single_page',
        entry_name: entry_name,
        count: count_total)
    else
      page = params[:page].to_i
      page_total = (count_total.to_f / per_page).ceil
      last_page_p = page >= page_total
      page_offset = (page - 1) * per_page
      t('helpers.search_results.multiple_pages',
        entry_name: entry_name,
        first: page_offset + 1,
        last: last_page_p ? count_total : page_offset + per_page,
        total: count_total)
    end.html_safe
  end
end
