FactoryGirl.define do
  factory :string_gist do
    type 'Abstract'
    string_field
    gist 'abc'
    parent_id 8
  end

  factory :location_string_gist, parent: :string_gist, class: 'LocationStringGist' do
    type 'LocationStringGist'
  end

  factory :person_string_gist, parent: :string_gist, class: 'PersonStringGist' do
    type 'PersonStringGist'
  end
end
    