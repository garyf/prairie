class LocationFieldSet < FieldSet

  def parent(location_id)
    Location.find(location_id)
  end
end
