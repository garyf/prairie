FactoryGirl.define do
  factory :numeric_gist do
    type 'Abstract'
    numeric_field
    gist 21.5
    parent_id 8
  end

  factory :location_numeric_gist, parent: :numeric_gist, class: 'LocationNumericGist' do
    type 'LocationNumericGist'
  end

  factory :person_numeric_gist, parent: :numeric_gist, class: 'PersonNumericGist' do
    type 'PersonNumericGist'
  end
end
    