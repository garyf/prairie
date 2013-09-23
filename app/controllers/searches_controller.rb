class SearchesController < ApplicationController

  respond_to :html

  def cache_read(key, redirect_path, klass)
    redirect_to redirect_path and return unless key && params[:page]
    @search_cache = SearchCache.new(key)
    @search_results_for_page = klass.search_results_fetch(@search_cache, params[:page])
    redirect_to redirect_path and return if @search_results_for_page.empty?
    @results_count = @search_cache.result_ids_count
  end
end
