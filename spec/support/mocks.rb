def with_errors_double
  @errors = double('errors')
  @errors.stub(:empty?) { false } # activerecord/lib/active_record/relation.rb, line 246
end

def checkbox_boolean_field_mk(stubs = {})
  (@checkbox_boolean_field_mock ||= mock_model(CheckboxBooleanField).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def choice_mk(stubs = {})
  (@choice_mock ||= mock_model(Choice).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def education_level_mk(stubs = {})
  (@education_level_mock ||= mock_model(EducationLevel).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def location_field_set_mk(stubs = {})
  (@location_field_set_mock ||= mock_model(LocationFieldSet).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def location_mk(stubs = {})
  (@location_mock ||= mock_model(Location).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def numeric_field_mk(stubs = {})
  (@numeric_field_mock ||= mock_model(NumericField).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def person_field_set_mk(stubs = {})
  (@person_field_set_mock ||= mock_model(PersonFieldSet).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def person_mk(stubs = {})
  (@person_mock ||= mock_model(Person).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def radio_button_field_mk(stubs = {})
  (@radio_button_field_mock ||= mock_model(RadioButtonField).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def select_field_mk(stubs = {})
  (@select_field_mock ||= mock_model(SelectField).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end

def string_field_mk(stubs = {})
  (@string_field_mock ||= mock_model(StringField).as_null_object).tap { |m| m.stub(stubs) unless stubs.empty? }
end
