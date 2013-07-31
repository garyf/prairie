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

private

  def bld
    @o = PersonSearch.new
  end
end
