require 'spec_helper'

feature 'SetupStringFields', :redis do
  before { @location_field_set = FactoryGirl.create(:location_field_set, name: 'Activities') }
  it 'create a new custom field, then edit it' do
    visit "/field_sets/#{@location_field_set.id}"
    expect(page).to have_content 'Custom fields'
    string_field_new 'Item', '3', '34'
    click_link 'Item'
    expect(page).to have_content 'Editing string field'
    fill_in 'Length min', with: '5'
    click_button 'Done'
    expect(page).to have_content 'String field successfully updated'
    click_link 'Item'
    expect(find('#string_field_length_min').value).to eql '5'
  end
end
