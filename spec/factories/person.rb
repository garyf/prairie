FactoryGirl.define do
  factory :person do
    sequence(:email) { |n| "jspieth-#{n}@example.com" }
    name_last 'Spieth'
    male_p true
  end

  factory :education_level do
    sequence(:name) { |n| "school-#{n}" }
  end
end
