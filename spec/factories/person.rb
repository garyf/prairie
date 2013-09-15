FactoryGirl.define do
  factory :person do
    sequence(:email) { |n| "jspieth-#{n}@example.com" }
    name_last 'Spieth'
    male_p true
  end
end
