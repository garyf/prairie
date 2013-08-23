class LocationSearch < Search

private

  def columns_searchable() [
    :description,
    :name]
  end

  def column_all_agree(columns, params)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Location.id_where_case_insensitive_value(c, v).pluck(:id)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + Location.id_where_case_insensitive_value(c, params[c.id2name]).pluck(:id) }
    ids
  end

  def all_agree_locations(all_agree_ids)
    all_agree_ids.empty? ? [] : Location.find(all_agree_ids)
  end

  def any_agree_locations(ids_by_agree_frequency)
    return [] if ids_by_agree_frequency.empty?
    ary = []
    ids_by_agree_frequency.each { |pair| ary = ary + Location.find(pair[1]) }
    ary
  end
end
