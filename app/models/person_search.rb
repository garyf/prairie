class PersonSearch < Search

  def people(params)
    ids = result_ids(PersonFieldSet.by_name, params)
    ids ? Person.name_last_by_ids(ids) : []
  end
end
