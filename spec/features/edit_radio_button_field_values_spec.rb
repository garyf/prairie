require 'spec_helper'

feature 'EditRadioButtonFieldValues', :redis do
  before do
    field_set = FactoryGirl.create(:location_field_set, name: 'Lakes')
    @location = FactoryGirl.create(:location, name: 'Lake Travis')
    visit "/field_sets/#{field_set.id}"
    radio_button_field_new 'Rentals?'
    choice_new 'Positive'
    choice_new 'Negative'
    choice_field_enable
    visit "/locations/#{@location.id}"
    click_link 'Lakes'
  end
  it 'enter an initial value, then edit it' do
    expect(page).to have_content 'Rentals?'
    click_link 'radio button, undefined'
    expect(page).to have_content 'Editing a radio button value'
    click_link 'Cancel'
    click_link 'radio button, undefined'
    choose 'Positive'
    click_button 'Done'
    expect(page).to have_content 'Radio button field successfully updated'
    click_link 'Positive'
    expect(page).to have_content 'Editing a radio button value'
    choose 'Negative'
    click_button 'Done'
    expect(page).to have_content 'Radio button field successfully updated'
    expect(page).to have_content 'Negative'
  end
end
