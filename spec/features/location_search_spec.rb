require 'spec_helper'

feature 'Location search w/o custom field' do
  before do
    location_new 'Tysons', 'mall'
    click_link 'Locations'
    click_link 'New search'
  end
  it 'w result' do
    expect(page).to have_content 'New search for locations'
    fill_in 'name', with: 'Tysons'
    click_button 'Search'
    expect(page).to have_content '1 search result'
    click_link 'Tysons'
    expect(page).to have_content 'mall'
  end
  it 'w/o result' do
    fill_in 'name', with: 'Reston'
    click_button 'Search'
    expect(page).to have_content 'No results found'
  end
end

feature 'Location search w custom field' do
  before do
    location = FactoryGirl.create(:location, name: 'Tysons')
    field_set = FactoryGirl.create(:location_field_set, name: 'Restaurants')
    @numeric_field = FactoryGirl.create(:location_numeric_field, field_set: field_set, name: 'Coffee shops')
    visit "/locations/#{location.id}"
    click_link 'Restaurants'
    click_link "field_#{@numeric_field.id}"
    fill_in 'numeric_field_gist', with: 34
    click_button 'Done'
    click_link 'Locations'
    click_link 'New search'
  end
  it 'w result' do
    fill_in "field_#{@numeric_field.id}_nbr_gist", with: 34
    click_button 'Search'
    expect(page).to have_content '1 search result'
    expect(page).to have_content 'Tysons'
  end
end
