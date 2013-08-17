class LocationSearch < Search

  def columns_searchable() [
    :description,
    :name]
  end

  def column_find_ids(params, any_agree_p = false)
    c = columns_searchable
    columns = c.delete_if { |sym| params[sym.id2name].blank? }
    return if columns.empty?
    any_agree_p ? column_any_agree(columns, params) : column_all_agree(columns, params)
  end

  def locations(params)
    result_ids = all_agree_find_ids(params)
    result_ids.empty? ? [] : Location.name_where_id_by_name(result_ids)
  end

private

  def column_all_agree(columns, params)
    result_ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Location.id_where_case_insensitive_value(c, v).pluck(:id)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def column_any_agree(columns, params)
    result_ids = []
    columns.each do |c|
      v = params[c.id2name]
      result_ids = result_ids | Location.id_where_case_insensitive_value(c, v).pluck(:id)
    end
    result_ids
  end
end
