def with_errors_double
  @errors = double('errors')
  @errors.stub(:empty?) { false } # activerecord/lib/active_record/relation.rb, line 246
end

def person_field_set_mk(stubs = {})
  (@person_field_set_mock ||= mock_model(PersonFieldSet).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def person_mk(stubs = {})
  (@person_mock ||= mock_model(Person).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end
