json.array!(@field_sets) do |field_set|
  json.extract! field_set, :type, :name, :description
  json.url field_set_url(field_set, format: :json)
end
