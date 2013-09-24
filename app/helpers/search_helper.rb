module SearchHelper

  def search_results_count
    t('helpers.search_results.count', count: @results_count || 0)
  end

  def search_results_info(results_count, params = params)
    name = entry_name(results_count, params)
    per_page = SearchCache::RESULTS_PER_PAGE
    if results_count < per_page + 1
      t('helpers.search_results.single_page',
        entry_name: name,
        count: results_count)
    else
      page = params[:page].to_i
      page_offset = (page - 1) * per_page
      t('helpers.search_results.multiple_pages',
        entry_name: name.capitalize,
        first: page_offset + 1,
        last: last_search_page?(results_count, page, per_page) ? results_count : page_offset + per_page)
    end.html_safe
  end

  def search_pagination_nav(results_count, params = params)
    page = params[:page].to_i
    last_page_p = last_search_page?(results_count, page, SearchCache::RESULTS_PER_PAGE)
    ary = []
    return ary if page == 1 && last_page_p
    ary << (page > 1 ? link_to_page('First', 1, params) : disabled_page('First')).html_safe
    ary << link_to_page('Prev', page - 1, params).html_safe if page > 2
    ary << (last_page_p ? disabled_page('Last') : link_to_page('Next', page + 1, params)).html_safe
    ary
  end

# not publicly used

  def last_search_page?(results_count, page, per_page)
    page >= (results_count.to_f / per_page).ceil
  end

  def entry_name(results_count, params)
    str = params[:controller].split('_')[0]
    str = str.pluralize unless results_count == 1
    str
  end

  def link_to_page(name, page, params)
    "<li>#{link_to name, url_for(params.merge page: page)}</li>"
  end

  def disabled_page(name)
    "<li class=disabled>#{link_to name, '#'}</li>"
  end
end
