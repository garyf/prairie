class LocationFieldSet < FieldSet

  def parent(location_id)
    Location.find(location_id)
  end

  def index_on_gist_delete(field_id, location_ids)
    return if location_ids.empty?
    Location.id_where_id(location_ids).each { |o| o.index_on_gist_delete field_id }
  end
end
