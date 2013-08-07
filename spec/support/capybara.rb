def numeric_field_new(name, min, max)
  click_link 'Numeric'
  fill_in 'Name', with: name
  fill_in 'Value min', with: min
  fill_in 'Value max', with: max
  click_button 'Done'
  expect(page).to have_content 'Numeric field successfully created'
end

def string_field_new(name, min, max)
  click_link 'String'
  fill_in 'Name', with: name
  fill_in 'Length min', with: min
  fill_in 'Length max', with: max
  click_button 'Done'
  expect(page).to have_content 'String field successfully created'
end
