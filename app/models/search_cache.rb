class SearchCache

  include Redis::Objects

  RESULTS_PER_PAGE = 10

  def initialize(key)
    @key = key
  end

  def result_ids_count
    redis.llen @key
  end

  def result_ids_fetch(page)
    redis.lrange @key, page_begin(page), page_end(page)
  end

private

  def page_begin(page)
    (page.to_i - 1) * RESULTS_PER_PAGE
  end

  def page_end(page)
    page.to_i * RESULTS_PER_PAGE - 1
  end
end
