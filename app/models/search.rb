class Search

  include Redis::Objects

  FIELD_GIST_KEY = %r{^field_\d+_[gist]+}
  FIELD_SUBSTRING_GIST_KEY = %r{^field_\d+_substring_gist$}
  RESULTS_COUNT_MIN = 55
  RESULTS_PER_PAGE = 25
  SUBSTRING_MIN = 3

  def self.page_begin(page)
    (page.to_i - 1) * RESULTS_PER_PAGE
  end

  def self.page_end(page)
    page.to_i * RESULTS_PER_PAGE - 1
  end

  def self.result_ids_fetch(key, page)
    redis.lrange(key, page_begin(page), page_end(page))
  end

  def column_all_gather_ids(params)
    columns = columns_w_values(params)
    column_all_agree(columns, params) unless columns.empty?
  end

  def custom_all_gather_ids(params)
    hsh = params_custom_w_values(params)
    custom_all_agree(hsh) unless hsh.empty?
  end

  def column_substring_gather_ids(params)
    columns = columns_w_substring_values(params)
    column_substring_agree(columns, params) unless columns.empty?
  end

  def custom_substring_gather_ids(params)
    hsh = params_custom_w_substring_values(params)
    custom_substring_agree(hsh) unless hsh.empty?
  end

  def all_agree_ids_for_find(params, substring_p = false)
    column_ids = substring_p ? column_substring_gather_ids(params) : column_all_gather_ids(params)
    return [] if column_ids.try(:empty?)
    custom_ids = substring_p ? custom_substring_gather_ids(params) : custom_all_gather_ids(params)
    return [] if custom_ids.try(:empty?)
    if custom_ids
      column_ids ? column_ids & custom_ids : custom_ids
    else
      column_ids ? column_ids : []
    end
  end

  def column_any_gather_ids(params)
    columns = columns_w_values(params)
    columns.empty? ? [] : column_any_agree(columns, params)
  end

  def custom_any_gather_ids(params)
    hsh = params_custom_w_values(params)
    hsh.empty? ? [] : custom_any_agree(hsh)
  end

  def any_agree_ids_for_find(params, all_ids)
    column_any_gather_ids(params) + custom_any_gather_ids(params) - all_ids
  end

  # return a hash of {parent_id: agree_frequency} pairs
  def parent_distribution(ids)
    return {} if ids.empty?
    ids.inject(Hash.new 0) do |hsh, i|
      hsh[i] += 1
      hsh
    end
  end

  # return an array of [agree_frequency, [parent_ids]] pairs, ordered by frequency descending
  def ids_grouped_by_agree_frequency(parent_distribution_hsh)
    return [] if parent_distribution_hsh.empty?
    hsh = {}
    parent_distribution_hsh.each { |k, v| hsh[v] ? (hsh[v] << k) : hsh[v] = [k] }
    hsh.sort.reverse
  end

  # return an array of ids, preserving their 'by relevance' order
  def groups_flatten(grouped_ids)
    grouped_ids.inject([]) { |ary, pair| ary + pair[1] }
  end

  def result_ids_by_relevance(params)
    all_ids = all_agree_ids_for_find(params)
    return [all_ids] unless all_agree_ids_few?(all_ids)
    any_agree_hsh = parent_distribution(any_agree_ids_for_find params, all_ids)
    result_ids = all_ids + ids_by_relevance(any_agree_hsh)
    any_ids = any_agree_hsh.keys
    return result_ids unless any_agree_ids_few?(all_ids, any_ids)
    substring_ids = all_agree_ids_for_find(params, true) - all_ids - any_ids
    return result_ids unless substring_ids.any?
    substring_agree_hsh = parent_distribution(substring_ids)
    result_ids + ids_by_relevance(substring_agree_hsh)
  end

  def result_ids_store(old_key, params)
    redis.del(old_key) if old_key
    ids = result_ids_by_relevance(params)
    return if ids.empty?
    key = result_ids_redis_key
    redis.rpush(key, ids)
    redis.expire(key, 900)
    key
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
  end

  def substring_value_reject?(value)
    value.blank? || value.length < SUBSTRING_MIN
  end

  def columns_w_substring_values(params)
    columns_searchable.delete_if { |sym| substring_value_reject?(params[sym.id2name]) }
  end

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
  end

  def params_custom_w_substring_values(params)
    params.select { |k, v| k =~ FIELD_SUBSTRING_GIST_KEY unless substring_value_reject?(v) }
  end

  def custom_all_agree(hsh)
    ids = nil
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      value_ids = o.parents_find_by_gist(v)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def custom_any_agree(hsh)
    ids = []
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      ids = ids + o.parents_find_by_gist(v)
    end
    ids
  end

  def custom_substring_agree(hsh)
    ids = nil
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      value_ids = o.parents_find_by_substring(v)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def all_agree_ids_few?(all_ids)
    all_ids.length < RESULTS_COUNT_MIN
  end

  def any_agree_ids_few?(all_ids, any_ids)
    all_ids.length + any_ids.length < RESULTS_COUNT_MIN
  end

  def ids_by_relevance(parent_distribution_hsh)
    grouped_ids = ids_grouped_by_agree_frequency(parent_distribution_hsh)
    groups_flatten(grouped_ids)
  end

  def unique_redis_key_generate(kind)
    str = "#{kind}:search:ids:"
    str << loop do
      key = SecureRandom.hex(8)
      break key unless redis.exists(str + key)
    end
  end
end
