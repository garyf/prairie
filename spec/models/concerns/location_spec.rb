require 'spec_helper'

describe Location do
  context '#gist_store, #gist_fetch', :redis do
    before do
      c_location_bs
      @field_id = '3'
    end
    context 'w gist, relies on custom field caller for validation' do
      before { @o.gist_store(@field_id, 'invalid_value', false) }
      it { expect(@o.gist_fetch @field_id).to eql 'invalid_value'}
    end
    context 'w/o gist' do
      before { @o.gist_store(@field_id, '', false) }
      it { expect(@o.gist_fetch @field_id).to be nil }
    end
  end

  context 'w 2 custom fields each w gist', :redis do
    before do
      @numeric_field0 = c_location_numeric_field_cr
      @numeric_field1 = c_location_numeric_field_cr
      @o = c_location_cr
      @numeric_field0.gist_store(@o, {'gist' => '34'})
      @numeric_field1.gist_store(@o, {'gist' => '89'})
    end
    it { expect(@o.field_values.count).to eql 2 }
    it do
      expect(@numeric_field0.parents.count).to eql 1
      expect(@numeric_field1.parents.count).to eql 1
    end
    it '#index_on_gist_add, #parents_find_by_gist' do
      expect(@numeric_field0.parents_find_by_gist '34').to eql [@o.id]
      expect(@numeric_field1.parents_find_by_gist '89').to eql [@o.id]
    end

    describe '#garbage_collect_and_self_destroy' do
      before { @o.garbage_collect_and_self_destroy }
      it '#remove_self_from_custom_field_parents' do
        expect(@numeric_field0.parents.empty?).to be true
        expect(@numeric_field1.parents.empty?).to be true
      end
      it '#index_on_gist_remove' do
        expect(@numeric_field0.parents_find_by_gist '34').to eql []
        expect(@numeric_field1.parents_find_by_gist '89').to eql []
      end
      it { expect(@o.field_values.empty?).to be true }
    end
  end
end
