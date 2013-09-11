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

  def column_agree(columns, params, substring_p)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = substring_p ? Person.id_where_ILIKE_value(c, v) : Person.id_where_case_insensitive_value(c, v)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + Person.id_where_case_insensitive_value(c, params[c.id2name]) }
    ids
  end

  def result_ids_redis_key
    unique_redis_key_generate('person')
  end
end
