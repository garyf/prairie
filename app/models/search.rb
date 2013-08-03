class Search

  def custom_result_ids(field_sets, params)
    result_ids = nil
    field_sets.each do |set|
      set.custom_fields.each do |o|
        v = params["field_#{o.id}_gist"]
        next if v.blank?
        value_ids = o.parents_find_by_gist(v)
        result_ids = result_ids ? value_ids & result_ids : value_ids
        return [] if result_ids.empty?
      end
    end
    result_ids
  end

  def column_and_custom_ids(field_sets, params)
    column_ids = column_result_ids(params)
    return [] if column_ids.try(:empty?)
    custom_ids = custom_result_ids(field_sets, params)
    return [] if custom_ids.try(:empty?)
    if custom_ids
      column_ids ? column_ids & custom_ids : custom_ids
    else
      column_ids ? column_ids : []
    end
  end
end
