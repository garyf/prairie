require 'spec_helper'

describe Person do
  context '#gist_store, #gist_fetch', :redis do
    before do
      c_person_bs
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

  context '#parents_find_by_gist', :redis do
    before do
      @string_field = c_person_string_field_bs
      c_person_bs
      @string_field.gist_store(@o, {'gist' => 'Foo'})
    end
    it { expect(@string_field.parents_find_by_gist 'Foo').to eql [@o.id] }

    describe '#gist_store w #index_on_gist_remove' do
      before { @string_field.gist_store(@o, {'gist' => 'Bar'}) }
      it do
        expect(@string_field.parents_find_by_gist 'Foo').to eql []
        expect(@string_field.parents_find_by_gist 'Bar').to eql [@o.id]
      end
    end
  end

  context 'w 2 custom fields each w gist', :redis do
    before do
      @string_field0 = c_person_string_field_cr
      @string_field1 = c_person_string_field_cr
      @o = c_person_cr
      @string_field0.gist_store(@o, {'gist' => 'Foo'})
      @string_field1.gist_store(@o, {'gist' => 'Bar'})
    end
    it { expect(@o.field_values.count).to eql 2 }
    it do
      expect(@string_field0.parents.count).to eql 1
      expect(@string_field1.parents.count).to eql 1
    end
    it '#index_on_gist_add, #parents_find_by_gist' do
      expect(@string_field0.parents_find_by_gist 'Foo').to eql [@o.id]
      expect(@string_field1.parents_find_by_gist 'Bar').to eql [@o.id]
    end

    describe '#garbage_collect_and_self_destroy' do
      before { @o.garbage_collect_and_self_destroy }
      it '#remove_self_from_custom_field_parents' do
        expect(@string_field0.parents.empty?).to be true
        expect(@string_field1.parents.empty?).to be true
      end
      it '#index_on_gist_remove' do
        expect(@string_field0.parents_find_by_gist 'Foo').to eql []
        expect(@string_field1.parents_find_by_gist 'Bar').to eql []
      end
      it { expect(@o.field_values.empty?).to be true }
    end
  end
end
