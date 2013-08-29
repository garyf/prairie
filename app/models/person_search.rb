class PersonSearch < Search

  def self.people_fetch(key, page)
    ids = redis.lrange(key, 0, 99)
    Person.name_last_where_ids_preserve_order(ids)
  end

private

  def columns_searchable() [
    :email,
    :name_first,
    :name_last]
  end

  def column_all_agree(columns, params)
    ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Person.id_where_case_insensitive_value(c, v).pluck(:id)
      ids = ids ? value_ids & ids : value_ids
      return [] if ids.empty?
    end
    ids
  end

  def column_any_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + Person.id_where_case_insensitive_value(c, params[c.id2name]).pluck(:id) }
    ids
  end

  def column_substring_agree(columns, params)
    ids = []
    columns.each { |c| ids = ids + Person.id_where_ILIKE_value(c, params[c.id2name]).pluck(:id) }
    ids
  end
end
