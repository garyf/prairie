class PersonSearch < Search

  def self.people_fetch(search_cache, page)
    Person.name_last_where_ids_preserve_order(search_cache.result_ids_fetch page)
  end

private

  def columns_searchable() [
    :birth_year,
    :education_level_id,
    :email,
    :height,
    :male_p,
    :name_first,
    :name_last]
  end

  def columns_categorical() [
    :education_level_id,
    :male_p]
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
      near_p ? Person.id_where_numeric_range(col, val) : Person.id_where_value(col, val)
    else
      Person.id_where_value(col, val)
    end
  end

  def result_ids_redis_key
    unique_redis_key_generate('person')
  end
end
