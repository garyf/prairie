require 'spec_helper'

feature 'Locations' do
  it 'create a new location, edit it, then visit index' do
    visit '/locations'
    click_link 'New location'
    expect(page).to have_content 'Name'
    fill_in 'Name', with: 'Oxford'
    click_button 'Done'
    expect(page).to have_content 'Location successfully created'
    click_link 'Edit'
    fill_in 'Description', with: 'Lorem ipsum'
    click_button 'Done'
    expect(page).to have_content 'Location successfully updated'
    click_link 'Locations'
    expect(page).to have_content 'Oxford'
  end
end
