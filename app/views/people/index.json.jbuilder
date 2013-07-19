json.array!(@people) do |person|
  json.extract! person, :email, :name_first, :name_last
  json.url person_url(person, format: :json)
end
