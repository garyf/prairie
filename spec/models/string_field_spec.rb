require 'spec_helper'

describe StringField do
  context '#constraints_store, #constraints_fetch', :redis do
    before do
      c_person_string_field_bs
      @params_white = {
        'length_max' => 34,
        'length_min' => 3}
    end
    describe 'passing field_set_id' do
      before do
        set_id = @o.field_set.id
        @o.should_receive(:field_row_create).with(set_id)
        @o.constraints_store(@params_white, set_id)
        @o.constraints_fetch
      end
      it do
        expect(@o.length_max).to eql '34'
        expect(@o.length_min).to eql '3'
      end
    end

    describe 'w/o passing field_set_id' do
      before do
        @o.should_not_receive(:field_row_create)
        @o.constraints_store(@params_white)
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
