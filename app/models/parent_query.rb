module ParentQuery

  def column_where_ids_preserve_order(column, ids)
    hsh = select(:id, column).where(id: ids).group_by(&:id)
    ids.map { |k| hsh[k.to_i].first }
  end

  def id_where_case_insensitive_value(column, value)
    where("lower(#{column}) = ?", value.downcase).pluck(:id)
  end

  def id_where_numeric_range(column, value)
    where("#{column}" => range_near(value)).pluck(:id)
  end

  def id_where_value(column, value)
    where("#{column}" => value).pluck(:id)
  end

  def id_where_id(ids)
    select(:id).where(id: ids)
  end
end
