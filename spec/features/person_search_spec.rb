require 'spec_helper'

feature 'PersonSearch' do
  it 'w result' do
    person_new 'Edwards', 'mike@example.com'
    click_link 'People'
    click_link 'New search'
    expect(page).to have_content 'New search for people'
    fill_in 'name_last', with: 'Edwards'
    click_button 'Search'
    expect(page).to have_content 'Search results'
    expect(page).to have_content 'By last name'
    click_link 'Edwards'
    expect(page).to have_content 'mike@example.com'
  end
end
