require 'spec_helper'

feature 'EditStringFieldValues', :redis do
  before do
    field_set = FactoryGirl.create(:person_field_set, name: 'Kitchen')
    @person = FactoryGirl.create(:person, name_last: 'Williams')
    visit "/field_sets/#{field_set.id}"
    string_field_new 'Lunch', '3', '34'
    visit "/people/#{@person.id}"
    click_link 'Kitchen'
  end
  it 'enter an initial value, then edit it' do
    expect(page).to have_content 'Lunch'
    click_link 'string, undefined'
    expect(page).to have_content 'Editing string value'
    fill_in 'string_field_gist', with: 'hamburger'
    click_button 'Done'
    expect(page).to have_content 'String field successfully updated'
    expect(page).to have_content 'Lunch'
    click_link 'hamburger'
    expect(page).to have_content 'Editing string value'
    fill_in 'string_field_gist', with: 'pickle'
    click_button 'Done'
    expect(page).to have_content 'String field successfully updated'
    expect(page).to have_content 'pickle'
  end
end
