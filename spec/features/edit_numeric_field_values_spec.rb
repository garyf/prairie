require 'spec_helper'

feature 'EditNumericFieldValues', :redis do
  before do
    field_set = FactoryGirl.create(:person_field_set, name: 'Kitchen')
    @person = FactoryGirl.create(:person, name_last: 'Williams')
    visit "/field_sets/#{field_set.id}"
    numeric_field_new 'Plates', '8', '16'
    visit "/people/#{@person.id}"
    click_link 'Kitchen'
  end
  it 'enter an initial value, then edit it' do
    expect(page).to have_content 'Plates'
    click_link 'numeric, undefined'
    expect(page).to have_content 'Editing numeric value'
    fill_in 'numeric_field_gist', with: '13'
    click_button 'Done'
    expect(page).to have_content 'Numeric field successfully updated'
    expect(page).to have_content 'Plates'
    click_link '13'
    expect(page).to have_content 'Editing numeric value'
    fill_in 'numeric_field_gist', with: '8'
    click_button 'Done'
    expect(page).to have_content 'Numeric field successfully updated'
    expect(page).to have_content '8'
  end
end
