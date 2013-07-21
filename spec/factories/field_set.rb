FactoryGirl.define do
  factory :field_set do
    type 'Abstract'
    sequence(:name) { |n| "twilight-mountain-#{n}" }
  end

  factory :location_field_set, parent: :field_set, class: 'LocationFieldSet' do
    type 'LocationFieldSet'
  end

  factory :person_field_set, parent: :field_set, class: 'PersonFieldSet' do
    type 'PersonFieldSet'
  end
end
