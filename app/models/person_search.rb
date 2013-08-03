class PersonSearch < Search

  def columns_searchable() [
    :email,
    :name_first,
    :name_last]
  end

  def column_result_ids(params)
    c = columns_searchable
    columns = c.delete_if { |sym| params[sym.id2name].blank? }
    return if columns.empty?
    result_ids = nil
    columns.each do |c|
      v = params[c.id2name]
      value_ids = Person.ids_by_case_insensitive_value(c, v).pluck(:id)
      result_ids = result_ids ? value_ids & result_ids : value_ids
      return [] if result_ids.empty?
    end
    result_ids
  end

  def people(params)
    result_ids = column_and_custom_ids(PersonFieldSet.by_name, params)
    result_ids.empty? ? [] : Person.name_last_by_ids(result_ids)
  end
end
