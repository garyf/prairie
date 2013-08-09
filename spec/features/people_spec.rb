require 'spec_helper'

feature 'People' do
  it 'create a new person, edit it, then visit index' do
    person_new('Brahams', 'vienna@example.org')
    click_link 'Edit'
    fill_in 'Name first', with: 'Johannes'
    click_button 'Done'
    expect(page).to have_content 'Person successfully updated'
    click_link 'People'
    expect(page).to have_content 'Johannes'
  end
end
