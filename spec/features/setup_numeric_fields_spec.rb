require 'spec_helper'

feature 'SetupNumericFields', :redis do
  before { @person_field_set = FactoryGirl.create(:person_field_set, name: 'Vehicles') }
  it 'create a new custom field, then edit it' do
    visit "/field_sets/#{@person_field_set.id}"
    expect(page).to have_content 'Custom fields'
    numeric_field_new 'Mileage', '8', '55'
    click_link 'Mileage'
    expect(page).to have_content 'Editing numeric field'
    check 'numeric_field_only_integer_p'
    click_button 'Done'
    expect(page).to have_content 'Numeric field successfully updated'
    click_link 'Mileage'
    expect(find('#numeric_field_only_integer_p')).to be_checked
  end
end
