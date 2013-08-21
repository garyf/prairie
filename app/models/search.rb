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
    column_parent_appearances(columns, params)
  end

  def custom_parent_appearances(hsh)
    ids = []
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      ids = ids + o.parents_find_by_gist(v)
    end
    ids
  end

  def custom_any_gather_ids(params)
    hsh = params_custom_w_values(params)
    return [] if hsh.empty?
    custom_parent_appearances(hsh)
  end

  # return a hash with {k, v} as {parent_id: agree_frequency}
  def parent_distribution(ids)
    ids.inject(Hash.new 0) do |hsh, i|
      hsh[i] += 1
      hsh
    end
  end

  # return an array of pairs with each pair as [agree_frequency, [parent_ids]], ordered by frequency descending
  def parent_ids_by_agree_frequency(parent_ids)
    hsh = {}
    parent_distribution(parent_ids).each { |k, v| hsh[v] ? (hsh[v] << k) : hsh[v] = [k] }
    hsh.sort.reverse
  end

  def any_agree_ids_for_find(params, all_agree_ids)
    ids = column_any_gather_ids(params) + custom_any_gather_ids(params) - all_agree_ids
    return [] if ids.empty?
    parent_ids_by_agree_frequency(ids)
  end

  def all_and_any_agree_ids_for_find(params)
    all_agree_ids = all_agree_ids_for_find(params)
    if any_agree_ids_few?(all_agree_ids)
      [all_agree_ids, any_agree_ids_for_find(params, all_agree_ids)]
    else
      [all_agree_ids, []]
    end
  end

private

  def columns_w_values(params)
    columns_searchable.delete_if { |sym| params[sym.id2name].blank? }
  end

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
  end

  def custom_all_agree(hsh)
    result_ids = nil
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      value_ids = o.parents_find_by_gist(v)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def any_agree_ids_few?(all_agree_ids)
    all_agree_ids.length < RESULTS_COUNT_MIN
  end
end
