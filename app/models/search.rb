class Search

  FIELD_GIST_KEY = %r{^field_\d+_gist$}
  RESULTS_COUNT_MIN = 55

  def params_custom_w_values(params)
    params.select { |k, v| k =~ FIELD_GIST_KEY unless v.blank? }
  end

  def custom_result_ids(params)
    hsh = params_custom_w_values(params)
    result_ids = nil
    hsh.each do |k, v|
      o = CustomField.find(k.split('_')[1])
      value_ids = o.parents_find_by_gist(v)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def all_agree_find_ids(params)
    column_ids = column_find_ids(params)
    return [] if column_ids.try(:empty?)
    custom_ids = custom_result_ids(params)
    return [] if custom_ids.try(:empty?)
    if custom_ids
      column_ids ? column_ids & custom_ids : custom_ids
    else
      column_ids ? column_ids : []
    end
  end

  def any_agree_find_ids(params)
    [] # stub
  end

  def all_and_any_agree_find_ids(params)
    result_ids = all_agree_find_ids(params)
    if result_ids.length < RESULTS_COUNT_MIN
      any_agree_ids = any_agree_find_ids(params) - result_ids
      result_ids = result_ids << any_agree_ids
    end
    result_ids
  end
end
