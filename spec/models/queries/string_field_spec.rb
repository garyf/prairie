require 'spec_helper'

describe StringField do
  context '::enabled' do
    before { string_field_cr(enabled_p: false) }
    it { expect(StringField.enabled).to match_array [] }

    describe 'w 1 string_field enabled' do
      before { @o = string_field_cr }
      it { expect(StringField.enabled).to match_array [@o] }
    end
  end

private

  def field_set_cr
    @field_set = FactoryGirl.create(:location_field_set)
  end

  def string_field_cr(options = {})
    @field_set ||= field_set_cr
    FactoryGirl.create(:string_field, {
      field_set: @field_set}.merge(options))
  end
end
