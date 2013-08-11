def checkbox_boolean_field_new(name)
  click_link 'Checkbox'
  expect(page).to have_content 'New checkbox field'
  click_link 'Cancel'
  click_link 'Checkbox'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Checkbox field successfully created'
  expect(page).to have_content name
end

def checkbox_boolean_field_edit(name)
  click_link 'Edit'
  click_link 'Checkbox field'
  click_link 'Edit'
  click_link 'Cancel'
  click_link 'Edit'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Checkbox field successfully updated'
  expect(page).to have_content name
end

def choice_new(name)
  click_link 'New choice'
  click_link 'Cancel'
  click_link 'New choice'
  fill_in 'choice_name', with: name
  click_button 'Done'
  expect(page).to have_content 'Choice successfully created'
end

def choice_edit(name_old, name)
  click_link name_old
  expect(page).to have_content 'Editing a choice'
  click_link 'Cancel'
  click_link name_old
  fill_in 'choice_name', with: name
  click_button 'Done'
  expect(page).to have_content 'Choice successfully updated'
end

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

def radio_button_field_new(name)
  click_link 'Radio button'
  expect(page).to have_content 'New radio button field'
  click_link 'Cancel'
  click_link 'Radio button'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Radio button field successfully created'
  expect(page).to have_content name
end

def radio_button_field_edit(name)
  click_link 'Edit'
  click_link 'Radio button field'
  click_link 'Edit'
  click_link 'Cancel'
  click_link 'Edit'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Radio button field successfully updated'
  expect(page).to have_content name
end

def select_field_new(name)
  click_link 'Select list'
  expect(page).to have_content 'New select list field'
  click_link 'Cancel'
  click_link 'Select list'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Select list field successfully created'
  expect(page).to have_content name
end

def select_field_edit(name)
  click_link 'Edit'
  click_link 'Select list field'
  click_link 'Edit'
  click_link 'Cancel'
  click_link 'Edit'
  fill_in 'Name', with: name
  click_button 'Done'
  expect(page).to have_content 'Select list field successfully updated'
  expect(page).to have_content name
end

def string_field_new(name, min, max)
  click_link 'String'
  fill_in 'Name', with: name
  fill_in 'Length min', with: min
  fill_in 'Length max', with: max
  click_button 'Done'
  expect(page).to have_content 'String field successfully created'
end
