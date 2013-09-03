def c_location_bs(options = {})
  @o = FactoryGirl.build_stubbed(:location, options)
end

def c_location_cr(options = {})
  FactoryGirl.create(:location, options)
end

def c_location_numeric_field_bs(options = {})
  @o = FactoryGirl.build_stubbed(:location_numeric_field, options)
end

def c_person_bs(options = {})
  @o = FactoryGirl.build_stubbed(:person, options)
end

def c_person_cr(options = {})
  FactoryGirl.create(:person, options)
end

def c_person_string_field_bs(options = {})
  @o = FactoryGirl.build_stubbed(:person_string_field, options)
end

def c_person_string_field_cr(options = {})
  FactoryGirl.create(:person_string_field, options)
end
