class LocationSearch < Search

  def self.locations_fetch(key, page)
    Location.name_where_ids_preserve_order(result_ids_fetch key, page)
  end

private

  def columns_searchable() [
    :description,
    :name]
  end

  def column_all_agree(columns, params)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Location.id_where_case_insensitive_value(c, v)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + Location.id_where_case_insensitive_value(c, params[c.id2name]) }
    ids
  end

  def column_substring_agree(columns, params)
    ids = nil
    columns.each do |c|
      value_ids = Location.id_where_ILIKE_value(c, params[c.id2name])
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def result_ids_redis_key
    unique_redis_key_generate('location')
  end
end
