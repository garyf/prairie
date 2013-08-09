def location_new(name, description = nil)
  visit '/locations'
  click_link 'New location'
  expect(page).to have_content 'Name'
  fill_in 'Name', with: name
  fill_in('Description', with: description) if description
  click_button 'Done'
  expect(page).to have_content 'Location successfully created'
end

def numeric_field_new(name, min, max)
  click_link 'Numeric'
  fill_in 'Name', with: name
  fill_in 'Value min', with: min
  fill_in 'Value max', with: max
  click_button 'Done'
  expect(page).to have_content 'Numeric field successfully created'
end

def person_new(name_last, email, name_first = nil)
  visit '/people'
  click_link 'New person'
  expect(page).to have_content 'Name first'
  fill_in('Name first', with: name_first) if name_first
  fill_in 'Name last', with: name_last
  fill_in 'Email', with: email
  click_button 'Done'
  expect(page).to have_content 'Person successfully created'
end

def string_field_new(name, min, max)
  click_link 'String'
  fill_in 'Name', with: name
  fill_in 'Length min', with: min
  fill_in 'Length max', with: max
  click_button 'Done'
  expect(page).to have_content 'String field successfully created'
end
