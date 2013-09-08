module SearchHelper

  def search_results_count
    t('helpers.search_results.count', count: @results_count || 0)
  end

  def last_search_page?(page, per_page)
    page >= (@results_count.to_f / per_page).ceil
  end

  def search_results_info(results_count, params = params)
    entry_name = params[:controller].split('_')[0]
    entry_name = entry_name.pluralize unless results_count == 1
    per_page = Search::RESULTS_PER_PAGE
    if results_count < per_page + 1
      t('helpers.search_results.single_page',
        entry_name: entry_name,
        count: results_count)
    else
      page = params[:page].to_i
      page_offset = (page - 1) * per_page
      t('helpers.search_results.multiple_pages',
        entry_name: entry_name.capitalize,
        first: page_offset + 1,
        last: last_search_page?(page, per_page) ? results_count : page_offset + per_page)
    end.html_safe
  end

  def search_pagination_nav
    page = params[:page].to_i
    last_page_p = last_search_page?(page, Search::RESULTS_PER_PAGE)
    ary = []
    return ary if page == 1 && last_page_p
    ary << (page > 1 ? "<li>#{link_to 'First', url_for(params.merge page: 1)}</li>" : "<li class=disabled>#{link_to 'First', '#'}</li>").html_safe
    ary << "<li>#{link_to 'Prev', url_for(params.merge page: page - 1)}</li>".html_safe if page > 2
    ary << (last_page_p ? "<li class=disabled>#{link_to 'Last', '#'}</li>" : "<li>#{link_to 'Next', url_for(params.merge page: page + 1)}</li>").html_safe
    ary
  end
end
