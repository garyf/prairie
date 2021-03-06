class Search

  include Redis::Objects

  FIELD_GIST_KEY = %r{^field_\d+_[nbr_gist]+}
  FIELD_NUMBER_GIST_KEY = %r{^field_\d+_nbr_gist$}
  FIELD_STRING_GIST_KEY = %r{^field_\d+_str_gist$}

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

  def near_ids_by_relevance(params, result_ids)
    return result_ids unless Settings.search.near_p
    near_ids = all_agree_ids_for_find(params, true) - result_ids
    return result_ids unless near_ids.any?
    near_agree_hsh = parent_distribution(near_ids)
    result_ids + ids_by_relevance(near_agree_hsh)
  end

  def any_ids_by_relevance(params, all_ids)
    return near_ids_by_relevance(params, all_ids) unless Settings.search.any_p
    any_agree_hsh = parent_distribution(any_agree_ids_for_find params, all_ids)
    result_ids = all_ids + ids_by_relevance(any_agree_hsh)
    result_ids_few?(result_ids) ? near_ids_by_relevance(params, result_ids) : result_ids
  end

  def result_ids_by_relevance(params)
    all_ids = all_agree_ids_for_find(params)
    result_ids_few?(all_ids) ? any_ids_by_relevance(params, all_ids) : all_ids
  end

  def result_ids_store(old_key, params)
    redis.del(old_key) if old_key
    ids = result_ids_by_relevance(params)
    return if ids.empty?
    key = result_ids_redis_key
    redis.rpush(key, ids)
    redis.expire(key, Settings.search.cache_expire_seconds)
    key
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
  end

  def columns_near_able
    columns_searchable - columns_categorical
  end

  def column_type_for(klass, column)
    sym = klass.columns_hash["#{column.id2name}"].type
    sym = :number if sym == :integer || sym == :float
    sym
  end

  def substring_value_reject?(col, val)
    return unless column_type(col) == :string
    val.length < Settings.search.substring_min
  end

  def columns_w_near_values(params)
    columns_near_able.delete_if do |col|
      val = params[col.id2name]
      val.blank? || substring_value_reject?(col, val)
    end
  end

  def column_type_query_for(klass, col, val, near_p = false)
    case column_type(col)
    when :string
      near_p ? klass.id_where_ILIKE_value(col, val) : klass.id_where_case_insensitive_value(col, val)
    when :number
      near_p ? klass.id_where_numeric_range(col, val) : klass.id_where_value(col, val)
    else
      klass.id_where_value(col, val)
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
          v.length >= Settings.search.substring_min
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

  def result_ids_few?(result_ids)
    result_ids.length < Settings.search.results_count_min
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
