require 'spec_helper'

feature 'SetupRadioButtonFields', :redis do
  before { @person_field_set = FactoryGirl.create(:person_field_set, name: 'Vehicles') }
  it 'create a new field, edit it, add a choice, then edit the choice' do
    visit "/field_sets/#{@person_field_set.id}"
    expect(page).to have_content 'Vehicles'
    radio_button_field_new 'Disabled?'
    radio_button_field_edit 'Enabled?'
    choice_new 'Yes'
    choice_edit 'Yes', 'True'
    click_link 'Vehicles (person)'
    click_link 'Enabled?'
    expect(page).to have_content 'Choices'
  end
end
