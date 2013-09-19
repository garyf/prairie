module ParentQuery

  def id_where_case_insensitive_value(column, value)
    where("lower(#{column}) = ?", value.downcase).pluck(:id)
  end

  def id_where_numeric_range(column, value)
    where("#{column}" => Search::value_range_near(value)).pluck(:id)
  end

  def id_where_value(column, value)
    where("#{column}" => value).pluck(:id)
  end

  def id_where_id(ids)
    select(:id).where(id: ids)
  end
end
