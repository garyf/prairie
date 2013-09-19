FactoryGirl.define do
  factory :choice do
    custom_field
    sequence(:name) { |n| "stormy-antler-#{n}" }
  end

  factory :custom_field do
    # field_set association with child factories
    sequence(:name) { |n| "windy-meadow-#{n}" }
  end

  factory :numeric_field, parent: :custom_field, class: 'NumericField' do
    type 'NumericField'
  end

  factory :location_numeric_field, parent: :custom_field, class: 'NumericField' do
    type 'NumericField'
    association :field_set, factory: :location_field_set, strategy: :build
  end

  factory :person_numeric_field, parent: :custom_field, class: 'NumericField' do
    type 'NumericField'
    association :field_set, factory: :person_field_set, strategy: :build
  end

  factory :string_field, parent: :custom_field, class: 'StringField' do
    type 'StringField'
  end

  factory :person_string_field, parent: :custom_field, class: 'StringField' do
    type 'StringField'
    association :field_set, factory: :person_field_set, strategy: :build
  end
end
