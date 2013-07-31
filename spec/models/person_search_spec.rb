require 'spec_helper'

describe PersonSearch do
  context '#result_ids' do
    before { bld }
    context 'w 1 field_set, 1 custom_field' do
      before do
        @string_field0 = string_field_mk
        @field_set0 = person_field_set_mk(custom_fields: [@string_field0])
      end
      describe 'w matching term' do
        before { @string_field0.should_receive(:parents_find_by_gist).with('foo') { ['8'] } }
        it { expect(@o.result_ids([@field_set0], {"field_#{@string_field0.id}_gist" => 'foo'})).to eql ['8'] }
      end
      describe 'w/o matching term' do
        before { @string_field0.should_receive(:parents_find_by_gist).with('bar') { [] } }
        it { expect(@o.result_ids([@field_set0], {"field_#{@string_field0.id}_gist" => 'bar'})).to be nil }
      end
    end
  end

  context '#people' do
    before do
      bld
      PersonFieldSet.should_receive(:by_name) { ['s1','s2'] }
      @params = {'field_21_gist' => 'seal brown'}
    end
    describe 'w ids' do
      before do
        @o.should_receive(:result_ids).with(['s1','s2'], @params) { ['13','55'] }
        Person.should_receive(:name_last_by_ids).with(['13','55']) { ['p21','p89'] }
      end
      it { expect(@o.people @params).to eql ['p21','p89'] }
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
