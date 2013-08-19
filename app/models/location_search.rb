class LocationSearch < Search

  def columns_searchable() [
    :description,
    :name]
  end

  def column_parent_appearances(columns, params)
    ids = []
    columns.each { |c| ids = ids + Location.id_where_case_insensitive_value(c, params[c.id2name]).pluck(:id) }
    ids
  end

  def locations(params)
    result_ids = all_agree_ids_for_find(params)
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
end
