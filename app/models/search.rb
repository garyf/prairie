class Search

  FIELD_GIST_KEY = %r{^field_\d+_gist$}
  RESULTS_COUNT_MIN = 55
  SUBSTRING_MIN = 3

  def column_all_gather_ids(params)
    columns = columns_w_values(params)
    column_all_agree(columns, params) unless columns.empty?
  end

  def custom_all_gather_ids(params)
    hsh = params_custom_w_values(params)
    custom_all_agree(hsh) unless hsh.empty?
  end

  def all_agree_ids_for_find(params)
    column_ids = column_all_gather_ids(params)
    return [] if column_ids.try(:empty?)
    custom_ids = custom_all_gather_ids(params)
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

  def column_substring_gather_ids(params)
    columns = columns_w_substring_values(params)
    return [] if columns.empty?
    column_substring_agree(columns, params)
  end

  def custom_substring_gather_ids(params)
    [] # stub
  end

  # return a hash of {parent_id: agree_frequency} pairs
  def parent_distribution(ids)
    return {} if ids.empty?
    ids.inject(Hash.new 0) do |hsh, i|
      hsh[i] += 1
      hsh
    end
  end

  def any_agree_ids_for_find(params, all_ids)
    column_any_gather_ids(params) + custom_any_gather_ids(params) - all_ids
  end

  def substring_agree_ids_for_find(params, all_ids, any_ids)
    column_substring_gather_ids(params) + custom_substring_gather_ids(params) - all_ids - any_ids
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
    substring_agree_hsh = parent_distribution(substring_agree_ids_for_find params, all_ids, any_ids)
    result_ids + ids_by_relevance(substring_agree_hsh)
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
  end

  def columns_w_substring_values(params)
    columns_searchable.delete_if do |sym|
      v = params[sym.id2name]
      v.blank? || v.length < SUBSTRING_MIN
    end
  end

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
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
end
