FactoryGirl.define do
  factory :custom_field do
    # field_set association with child factories
    sequence(:name) { |n| "windy-meadow-#{n}" }
  end

  factory :string_field, parent: :custom_field, class: 'StringField' do
    type 'StringField'
  end

  factory :person_string_field, parent: :custom_field, class: 'StringField' do
    type 'StringField'
    association :field_set, factory: :person_field_set, strategy: :build
  end
end
