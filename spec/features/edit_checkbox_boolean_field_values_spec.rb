require 'spec_helper'

feature 'EditCheckboxBooleanFieldValues', :redis do
  before do
    field_set = FactoryGirl.create(:location_field_set, name: 'Lakes')
    @location = FactoryGirl.create(:location, name: 'Lake Travis')
    visit "/field_sets/#{field_set.id}"
    checkbox_boolean_field_new 'Rentals?'
    choice_new 'Positive'
    choice_new 'Negative'
    visit "/locations/#{@location.id}"
    click_link 'Lakes'
  end
  it 'enter an initial value, then edit it' do
    expect(page).to have_content 'Rentals?'
    click_link 'checkbox, undefined'
    expect(page).to have_content 'Editing a checkbox value'
    click_link 'Cancel'
    click_link 'checkbox, undefined'
    check 'choice_field_gist'
    click_button 'Done'
    expect(page).to have_content 'Checkbox field successfully updated'
    click_link 'Positive'
    expect(page).to have_content 'Editing a checkbox value'
    uncheck 'choice_field_gist'
    click_button 'Done'
    expect(page).to have_content 'Checkbox field successfully updated'
    expect(page).to have_content 'Negative'
  end
end
