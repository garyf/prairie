json.array!(@field_rows) do |field_row|
  json.extract! field_row, :custom_field_id, :field_set_id, :row
  json.url field_row_url(field_row, format: :json)
end
