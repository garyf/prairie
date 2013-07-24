require 'spec_helper'

describe NumericField do
  context '#constraints_store, #constraints_fetch', :redis do
    before do
      c_location_numeric_field_bs
      @params_white = {
        'only_integer_p' => '1',
        'value_max' => '233',
        'value_min' => '-144'}
    end
    describe 'passing field_set_id' do
      before do
        set_id = @o.field_set.id
        @o.should_receive(:field_row_create).with(set_id)
        @o.constraints_store(@params_white, set_id)
        @o.constraints_fetch
      end
      it do
        expect(@o.only_integer_p).to eql '1'
        expect(@o.value_max).to eql '233'
        expect(@o.value_min).to eql '-144'
      end
    end

    describe 'w/o passing field_set_id' do
      before do
        @o.should_not_receive(:field_row_create)
        @o.constraints_store(@params_white)
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
          'value_max' => '',
          'value_min' => ''})
        @o.constraints_fetch
      end
      it do
        expect(@o.value_max).to be nil
        expect(@o.value_min).to be nil
      end
    end
  end
end
