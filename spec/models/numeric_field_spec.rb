require 'spec_helper'

describe NumericField do
  context '#constraints_store, #constraints_fetch', :redis do
    before { c_location_numeric_field_bs }
    describe 'when passing non-blank values' do
      before do
        @o.constraints_store({
          'only_integer_p' => '1',
          'value_max' => '233',
          'value_min' => '-144'})
        @o.constraints_fetch
      end
      it do
        expect(@o.only_integer_p).to eql '1'
        expect(@o.value_max).to eql '233'
        expect(@o.value_min).to eql '-144'
      end
    end

    describe '#constraints_store when passing blank values' do
      before do
        @o.constraints_store({
          'only_integer_p' => '',
          'value_max' => '',
          'value_min' => ''})
        @o.constraints_fetch
      end
      it do
        expect(@o.only_integer_p).to be nil
        expect(@o.value_max).to be nil
        expect(@o.value_min).to be nil
      end
    end
  end
end
