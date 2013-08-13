require 'spec_helper'

feature 'EditSelectFieldValues', :redis do
  before do
    field_set = FactoryGirl.create(:location_field_set, name: 'Lakes')
    @location = FactoryGirl.create(:location, name: 'Lake Travis')
    visit "/field_sets/#{field_set.id}"
    select_field_new 'Rentals?'
    choice_new 'Positive'
    choice_new 'Negative'
    choice_field_enable
    visit "/locations/#{@location.id}"
    click_link 'Lakes'
  end
  it 'enter an initial value, then edit it' do
    expect(page).to have_content 'Rentals?'
    click_link 'select list, undefined'
    expect(page).to have_content 'Editing a select list value'
    click_link 'Cancel'
    click_link 'select list, undefined'
    select 'Positive', from: 'choice_field_gist'
    click_button 'Done'
    expect(page).to have_content 'Select list field successfully updated'
    click_link 'Positive'
    expect(page).to have_content 'Editing a select list value'
    select 'Negative', from: 'choice_field_gist'
    click_button 'Done'
    expect(page).to have_content 'Select list field successfully updated'
    expect(page).to have_content 'Negative'
  end
end
