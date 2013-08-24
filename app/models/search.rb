class Search

  FIELD_GIST_KEY = %r{^field_\d+_gist$}
  RESULTS_COUNT_MIN = 55

  def column_all_gather_ids(params)
    columns = columns_w_values(params)
    return if columns.empty?
    column_all_agree(columns, params)
  end

  def custom_all_gather_ids(params)
    hsh = params_custom_w_values(params)
    return if hsh.empty?
    custom_all_agree(hsh)
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
    return [] if columns.empty?
    column_any_agree(columns, params)
  end

  def custom_any_gather_ids(params)
    hsh = params_custom_w_values(params)
    return [] if hsh.empty?
    custom_any_agree(hsh)
  end

  def column_substring_gather_ids(params)
    columns = columns_w_values(params)
    return if columns.empty?
    column_substring_agree(columns, params)
  end

  def custom_substring_gather_ids(params)
    [] # stub
  end

  # return a hash with {k, v} as {parent_id: agree_frequency}
  def parent_distribution(ids)
    ids.inject(Hash.new 0) do |hsh, i|
      hsh[i] += 1
      hsh
    end
  end

  def any_agree_frequency_by_parent(params, all_agree_ids)
    ids = column_any_gather_ids(params) + custom_any_gather_ids(params) - all_agree_ids
    ids.empty? ? {} : parent_distribution(ids)
  end

  def substring_agree_frequency_by_parent(params, all_agree_ids, any_agree_ids)
    ids = column_substring_gather_ids(params) + custom_substring_gather_ids(params) - all_agree_ids - any_agree_ids
    return {} if ids.empty?
    parent_distribution(ids)
  end

  # return an array of pairs with each pair as [agree_frequency, [parent_ids]], ordered by frequency descending
  def ids_grouped_by_agree_frequency(parent_distribution_hsh)
    hsh = {}
    parent_distribution_hsh.each { |k, v| hsh[v] ? (hsh[v] << k) : hsh[v] = [k] }
    hsh.sort.reverse
  end

  def any_agree_ids_for_find(any_agree_hsh)
    return [] if any_agree_hsh.empty?
    ids_grouped_by_agree_frequency(any_agree_hsh)
  end

  def substring_agree_ids_for_find(substring_agree_hsh)
    return [] if substring_agree_hsh.empty?
    ids_grouped_by_agree_frequency(substring_agree_hsh)
  end

  def all_and_any_agree_ids_for_find(params)
    all_agree_ids = all_agree_ids_for_find(params)
    return [all_agree_ids, []] unless all_agree_ids_few?(all_agree_ids)
    any_agree_hsh = any_agree_frequency_by_parent(params, all_agree_ids)
    [all_agree_ids, any_agree_ids_for_find(any_agree_hsh)]
  end

  def results_united(params)
    grouped_ids = all_and_any_agree_ids_for_find(params)
    all_agree_locations(grouped_ids[0]) + any_agree_locations(grouped_ids[1])
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
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

  def all_agree_ids_few?(all_agree_ids)
    all_agree_ids.length < RESULTS_COUNT_MIN
  end

  def any_agree_ids_few?(all_agree_ids, any_agree_ids)
    all_agree_ids.length + any_agree_ids.length < RESULTS_COUNT_MIN
  end
end
