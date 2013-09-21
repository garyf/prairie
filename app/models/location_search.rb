class LocationSearch < Search

private

  def columns_searchable() [
    :description,
    :name]
  end

  def columns_categorical
    []
  end

  def column_type(column)
    sym = Location.columns_hash["#{column.id2name}"].type
    sym = :number if sym == :integer || sym == :float
    sym
  end

  def column_type_query(col, val, near_p = false)
    case column_type(col)
    when :string
      near_p ? Location.id_where_ILIKE_value(col, val) : Location.id_where_case_insensitive_value(col, val)
    when :number
      near_p ? Location.id_where_numeric_range(col, val) : Location.id_where_value(col, val)
    else
      Location.id_where_value(col, val)
    end
  end

  def result_ids_redis_key
    unique_redis_key_generate('location')
  end
end
