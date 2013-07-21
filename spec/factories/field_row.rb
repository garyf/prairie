FactoryGirl.define do
  factory :person_string_field_row, class: 'FieldRow' do
    association :custom_field, factory: :string_field, strategy: :build
    association :field_set, factory: :person_field_set, strategy: :build
  end
end
