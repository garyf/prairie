json.array!(@choices) do |choice|
  json.extract! choice, :name, :custom_field_id, :row
  json.url choice_url(choice, format: :json)
end
