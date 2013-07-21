class PersonFieldSet < FieldSet

  def parent(person_id)
    Person.find(person_id)
  end
end
