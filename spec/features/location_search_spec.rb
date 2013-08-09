require 'spec_helper'

feature 'LocationSearch' do
  it 'w result' do
    location_new 'Tysons', 'mall'
    click_link 'Locations'
    click_link 'New search'
    expect(page).to have_content 'New search for locations'
    fill_in 'name', with: 'Tysons'
    click_button 'Search'
    expect(page).to have_content 'Search results'
    expect(page).to have_content 'By name'
    click_link 'Tysons'
    expect(page).to have_content 'mall'
  end
end
