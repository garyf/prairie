class Search

  FIELD_GIST_KEY = %r{^field_\d+_gist$}
  RESULTS_COUNT_MIN = 55

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
  end

  def custom_parent_appearances(hsh)
    ids = []
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      ids = ids + o.parents_find_by_gist(v)
    end
    ids
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

  def custom_find_ids(params, any_agree_p = false)
    hsh = params_custom_w_values(params)
    return if hsh.empty?
    any_agree_p ? custom_any_agree(hsh) : custom_all_agree(hsh)
  end

  def all_agree_find_ids(params)
    column_ids = column_find_ids(params)
    return [] if column_ids.try(:empty?)
    custom_ids = custom_find_ids(params)
    return [] if custom_ids.try(:empty?)
    if custom_ids
      column_ids ? column_ids & custom_ids : custom_ids
    else
      column_ids ? column_ids : []
    end
  end

  def any_agree_find_ids(params)
    column_ids = column_find_ids(params, true)
    custom_ids = custom_find_ids(params, true)
    if custom_ids
      if column_ids
        column_ids | custom_ids
      else
        custom_ids
      end
    else
      column_ids ? column_ids : []
    end
  end

  def all_and_any_agree_find_ids(params)
    result_ids = all_agree_find_ids(params)
    if result_ids.length < RESULTS_COUNT_MIN
      any_agree_ids = any_agree_find_ids(params) - result_ids
      result_ids = result_ids + any_agree_ids
    end
    result_ids
  end

private

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

  # preference given to parents having more fields that agree with the search terms
  def custom_any_agree(hsh)
    parent_ids = custom_parent_appearances(hsh)
    parent_ids_by_agree_frequency(parent_ids)
  end
end
