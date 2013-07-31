class Search

  def result_ids(field_sets, params)
    ids = nil
    field_sets.each do |set|
      set.custom_fields.each do |o|
        str = params["field_#{o.id}_gist"]
        next if str.blank?
        parent_ids = o.parents_find_by_gist(str)
        ids = ids ? parent_ids & ids : parent_ids
        return if result_ids.empty?
      end
    end
  end
end
