require 'spec_helper'

describe CustomField do
  context '#human_row' do
    before { @string_field0 = string_field_cr }
    it 'w 1 custom_field' do
      expect(@string_field0.human_row).to eql 1
    end

    describe 'w 2 custom_fields' do
      before { @string_field1 = string_field_cr(row_position: 0) }
      it do
        expect(@string_field0.human_row).to eql 2
        expect(@string_field1.human_row).to eql 1
      end
    end

    describe 'w 3 custom_fields' do
      before do
        @string_field1 = string_field_cr(row_position: 0)
        @string_field2 = string_field_cr(row_position: 0)
      end
      it do
        expect(@string_field0.human_row).to eql 3
        expect(@string_field1.human_row).to eql 2
        expect(@string_field2.human_row).to eql 1
      end
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
