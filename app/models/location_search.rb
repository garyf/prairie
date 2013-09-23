class LocationSearch < Search

private

  def columns_searchable() [
    :description,
    :elevation_feet,
    :lot_acres,
    :name,
    :public_p]
  end

  def columns_categorical
    [:public_p]
  end

  def column_type(column)
    column_type_for(Location, column)
  end

  def column_type_query(col, val, near_p = false)
    column_type_query_for(Location, col, val, near_p)
  end

  def result_ids_redis_key
    unique_redis_key_generate('location')
  end
end
