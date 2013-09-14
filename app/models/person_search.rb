class PersonSearch < Search

  def self.people_fetch(key, page)
    Person.name_last_where_ids_preserve_order(result_ids_fetch key, page)
  end

private

  def columns_searchable() [
    :birth_year,
    :email,
    :height,
    :name_first,
    :name_last]
  end

  def column_type(column)
    sym = Person.columns_hash["#{column.id2name}"].type
    sym = :number if sym == :integer || sym == :float
    sym
  end

  def column_type_query(col, val, near_p = false)
    case column_type(col)
    when :string
      near_p ? Person.id_where_ILIKE_value(col, val) : Person.id_where_case_insensitive_value(col, val)
    when :number
      near_p ? Person.id_where_numeric_value(col, val) : Person.id_where_numeric_value(col, val)
    else
      raise ColumnTypeNotRecognized
    end
  end

  def column_agree(columns, params, substring_p)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = column_type_query(c, v, substring_p)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + column_type_query(c, params[c.id2name]) }
    ids
  end

  def result_ids_redis_key
    unique_redis_key_generate('person')
  end
end
