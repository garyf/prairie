def c_person_bs(options = {})
  @o = FactoryGirl.build_stubbed(:person, options)
end

def c_person_string_field_bs(options = {})
  @o = FactoryGirl.build_stubbed(:person_string_field, options)
end
