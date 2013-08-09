require 'spec_helper'

feature 'Locations' do
  it 'create a new location, edit it, then visit index' do
    location_new('Oxford')
    click_link 'Edit'
    fill_in 'Description', with: 'Lorem ipsum'
    click_button 'Done'
    expect(page).to have_content 'Location successfully updated'
    click_link 'Locations'
    expect(page).to have_content 'Oxford'
  end
end
