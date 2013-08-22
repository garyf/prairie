require 'spec_helper'

feature 'Person search w/o custom field' do
  before do
    person_new 'Edwards', 'mike@example.com'
    click_link 'People'
    click_link 'New search'
  end
  it 'w result' do
    expect(page).to have_content 'New search for people'
    fill_in 'name_last', with: 'Edwards'
    click_button 'Search'
    expect(page).to have_content 'Search results'
    expect(page).to have_content 'By relevance'
    click_link 'Edwards'
    expect(page).to have_content 'mike@example.com'
  end
  it 'w/o result' do
    fill_in 'name_last', with: 'Davis'
    click_button 'Search'
    expect(page).to have_content 'No results found'
  end
end

feature 'Person search w custom field' do
  before do
    person = FactoryGirl.create(:person, name_last: 'Edwards', email: 'mike@example.com')
    field_set = FactoryGirl.create(:person_field_set, name: 'Recreation')
    @string_field = FactoryGirl.create(:person_string_field, field_set: field_set, name: 'Conditioning')
    visit "/people/#{person.id}"
    click_link 'Recreation'
    click_link "field_#{@string_field.id}"
    fill_in 'string_field_gist', with: 'Bicycle'
    click_button 'Done'
    click_link 'People'
    click_link 'New search'
  end
  it 'w result' do
    fill_in "field_#{@string_field.id}_gist", with: 'Bicycle'
    click_button 'Search'
    expect(page).to have_content 'Search results'
    expect(page).to have_content 'Edwards'
  end
end
