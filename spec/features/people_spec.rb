require 'spec_helper'

feature 'People' do
  it 'create a new person, edit it, then visit index' do
    visit '/people'
    click_link 'New person'
    expect(page).to have_content 'Name first'
    fill_in 'Name last', with: 'Brahams'
    fill_in 'Email', with: 'vienna@example.org'
    click_button 'Done'
    expect(page).to have_content 'Person successfully created'
    click_link 'Edit'
    fill_in 'Name first', with: 'Johannes'
    click_button 'Done'
    expect(page).to have_content 'Person successfully updated'
    click_link 'People'
    expect(page).to have_content 'Johannes'
  end
end
