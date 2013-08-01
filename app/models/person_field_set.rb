class PersonFieldSet < FieldSet

  def parent(person_id)
    Person.find(person_id)
  end

  def index_on_gist_delete(field_id, person_ids)
    return if person_ids.empty?
    Person.by_ids(person_ids).each { |o| o.index_on_gist_delete field_id }
  end
end
