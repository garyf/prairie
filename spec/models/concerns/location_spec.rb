require 'spec_helper'

describe Location do
  context '#gist_store, #gist_fetch', :redis do
    before do
      c_location_bs
      @field_id = '3'
    end
    context 'w gist, relies on custom field caller for validation' do
      before { @o.gist_store(@field_id, 'invalid_value') }
      it { expect(@o.gist_fetch @field_id).to eql 'invalid_value'}
    end
    context 'w/o gist' do
      before { @o.gist_store(@field_id, '') }
      it { expect(@o.gist_fetch @field_id).to be nil }
    end
  end

  context 'w 2 custom fields each w gist', :redis do
    before do
      @numeric_field0 = c_location_numeric_field_bs
      @numeric_field1 = c_location_numeric_field_bs
      c_location_bs
      @numeric_field0.gist_store(@o, {'gist' => '34'})
      @numeric_field1.gist_store(@o, {'gist' => '89'})
    end
    it do
      expect(@numeric_field0.parents.count).to eql 1
      expect(@numeric_field1.parents.count).to eql 1
    end
    it { expect(@o.field_values.count).to eql 2 }

    describe '#custom_fields_garbage_collect_and_self_destroy' do
      before do
        @o.should_receive(:destroy)
        @o.custom_fields_garbage_collect_and_self_destroy
      end
      it '#remove_self_from_custom_field_parents' do
        expect(@numeric_field0.parents.empty?).to be true
        expect(@numeric_field1.parents.empty?).to be true
      end
      it { expect(@o.field_values.empty?).to be true }
    end
  end
end
