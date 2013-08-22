class PersonSearch < Search

private

  def columns_searchable() [
    :email,
    :name_first,
    :name_last]
  end

  def column_all_agree(columns, params)
    result_ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Person.id_where_case_insensitive_value(c, v).pluck(:id)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def column_parent_appearances(columns, params)
    ids = []
    columns.each { |c| ids = ids + Person.id_where_case_insensitive_value(c, params[c.id2name]).pluck(:id) }
    ids
  end

  def all_agree_locations(all_agree_ids)
    all_agree_ids.empty? ? [] : Person.find(all_agree_ids)
  end

  def any_agree_locations(ids_by_agree_frequency)
    return [] if ids_by_agree_frequency.empty?
    ary = []
    ids_by_agree_frequency.each { |pair| ary = ary + Person.find(pair[1]) }
    ary
  end
end
