class LocationSearch < Search

  def columns_searchable() [
    :description,
    :name]
  end

  def column_result_ids(params)
    c = columns_searchable
    columns = c.delete_if { |sym| params[sym.id2name].blank? }
    return if columns.empty?
    result_ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Location.id_where_case_insensitive_value(c, v).pluck(:id)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def locations(params)
    result_ids = column_and_custom_ids(LocationFieldSet.by_name, params)
    result_ids.empty? ? [] : Location.name_where_id_by_name(result_ids)
  end
end
