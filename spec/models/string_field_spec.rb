require 'spec_helper'

describe StringField do
  context '#constraints_store, #constraints_fetch', :redis do
    before { c_person_string_field_bs }
    describe 'when passing non-blank values' do
      before do
        @o.constraints_store({
          'length_max' => '34',
          'length_min' => '3'})
        @o.constraints_fetch
      end
      it do
        expect(@o.length_max).to eql '34'
        expect(@o.length_min).to eql '3'
      end
    end

    describe '#constraints_store when passing blank values' do
      before do
        @o.constraints_store({
          'length_max' => '',
          'length_min' => ''})
        @o.constraints_fetch
      end
      it do
        expect(@o.length_max).to eql 255
        expect(@o.length_min).to eql 1
      end
    end
  end
end
