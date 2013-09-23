class PersonSearch < Search

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
    column_type_for(Person, column)
  end

  def column_type_query(col, val, near_p = false)
    column_type_query_for(Person, col, val, near_p)
  end

  def result_ids_redis_key
    unique_redis_key_generate('person')
  end
end
