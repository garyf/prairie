class Search

  FIELD_GIST_KEY = %r{^field_\d+_gist$}
  RESULTS_COUNT_MIN = 55

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
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

  def custom_any_agree(hsh)
    result_ids = []
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      result_ids = result_ids | o.parents_find_by_gist(v)
    end
    result_ids
  end
end
