require 'spec_helper'

feature 'PersonFieldSets' do
  it 'create a new set, edit it, then visit index' do
    visit '/field_sets'
    click_link 'New set for people'
    expect(page).to have_content 'Name'
    fill_in 'Name', with: 'Suppliers'
    click_button 'Done'
    expect(page).to have_content 'Person field set successfully created'
    click_link 'Suppliers'
    click_link 'Edit set'
    fill_in 'Description', with: 'Electronics'
    click_button 'Done'
    expect(page).to have_content 'Person field set successfully updated'
    expect(page).to have_content 'Electronics'
  end
end
