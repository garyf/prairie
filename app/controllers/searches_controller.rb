class SearchesController < ApplicationController

  respond_to :html

  def cache_read(klass, key, redirect_path)
    redirect_to redirect_path and return unless key && params[:page]
    @search_cache = SearchCache.new(key)
    @search_results_for_page = klass.search_results_fetch(@search_cache, params[:page])
    redirect_to redirect_path and return if @search_results_for_page.empty?
    @results_count = @search_cache.result_ids_count
  end

  def cache_write(klass, session_key, redirect_path)
    redis_key = klass.new.result_ids_store(session[session_key], params)
    if redis_key
      session[session_key] = redis_key
      redirect_to redirect_path
    else
      session[session_key] = nil
      @search_results_for_page = []
      render :index
    end
  end
end
