class Search

  include Redis::Objects

  FIELD_GIST_KEY = %r{^field_\d+_[nbr_gist]+}
  FIELD_NUMBER_GIST_KEY = %r{^field_\d+_nbr_gist$}
  FIELD_STRING_GIST_KEY = %r{^field_\d+_str_gist$}
  RANGE_NEAR_ADD = 15.0
  RANGE_NEAR_PCT = 0.9
  RESULTS_COUNT_MIN = 55
  RESULT_IDS_EXPIRE_SECONDS = 3600
  RESULTS_PER_PAGE = 10
  SUBSTRING_MIN = 3

  def self.page_begin(page)
    (page.to_i - 1) * RESULTS_PER_PAGE
  end

  def self.page_end(page)
    page.to_i * RESULTS_PER_PAGE - 1
  end

  def self.results_count(key)
    redis.llen(key)
  end

  def self.result_ids_fetch(key, page)
    redis.lrange(key, page_begin(page), page_end(page))
  end

  def column_gather_ids(params, near_p)
    columns = near_p ? columns_w_near_values(params) : columns_w_values(params)
    column_agree(columns, params, near_p) unless columns.empty?
  end

  def custom_gather_ids(params, near_p)
    hsh = near_p ? params_custom_w_near_values(params) : params_custom_w_values(params)
    custom_agree(hsh, near_p) unless hsh.empty?
  end

  def all_agree_ids_for_find(params, near_p = false)
    column_ids = column_gather_ids(params, near_p)
    return [] if column_ids.try(:empty?)
    custom_ids = custom_gather_ids(params, near_p)
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
    return all_ids unless all_agree_ids_few?(all_ids)
    any_agree_hsh = parent_distribution(any_agree_ids_for_find params, all_ids)
    result_ids = all_ids + ids_by_relevance(any_agree_hsh)
    any_ids = any_agree_hsh.keys
    return result_ids unless any_agree_ids_few?(all_ids, any_ids) && Settings.search.near_p
    near_ids = all_agree_ids_for_find(params, true) - all_ids - any_ids
    return result_ids unless near_ids.any?
    near_agree_hsh = parent_distribution(near_ids)
    result_ids + ids_by_relevance(near_agree_hsh)
  end

  def result_ids_store(old_key, params)
    redis.del(old_key) if old_key
    ids = result_ids_by_relevance(params)
    return if ids.empty?
    key = result_ids_redis_key
    redis.rpush(key, ids)
    redis.expire(key, RESULT_IDS_EXPIRE_SECONDS)
    key
  end

  def self.value_range_near(value)
    flt = value.to_f
    return (flt - 1.0)..(flt + 1.0) if flt.abs < RANGE_NEAR_ADD
    if flt > 0 
      s = (flt * RANGE_NEAR_PCT).floor
      e = (flt / RANGE_NEAR_PCT).ceil
    else
      s = (flt / RANGE_NEAR_PCT).floor
      e = (flt * RANGE_NEAR_PCT).ceil
    end
    s..e
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
  end

  def columns_near_able
    columns_searchable - columns_categorical
  end

  def substring_value_reject?(col, val)
    return unless column_type(col) == :string
    val.length < SUBSTRING_MIN
  end

  def columns_w_near_values(params)
    columns_near_able.delete_if do |col|
      val = params[col.id2name]
      val.blank? || substring_value_reject?(col, val)
    end
  end

  def column_agree(columns, params, near_p)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = column_type_query(c, v, near_p)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
  end

  def params_custom_w_near_values(params)
    params.select do |k, v|
      unless v.blank?
        if k =~ FIELD_STRING_GIST_KEY
          v.length >= SUBSTRING_MIN
        else
          k =~ FIELD_NUMBER_GIST_KEY
        end
      end
    end
  end

  def custom_field_assign(key)
    CustomField.find(key.split('_')[1])
  end

  def custom_agree(hsh, near_p)
    ids = nil
    hsh.each do |k, v|
      o = custom_field_assign(k)
      value_ids = near_p ? o.parents_find_near(v) : o.parents_find_by_gist(v)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + column_type_query(c, params[c.id2name]) }
    ids
  end

  def custom_any_agree(hsh)
    ids = []
    hsh.each do |k, v|
      o = custom_field_assign(k)
      ids = ids + o.parents_find_by_gist(v)
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
