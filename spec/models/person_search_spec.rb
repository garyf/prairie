require 'spec_helper'

describe PersonSearch do
  context '#people' do
    before do
      bld
      @params = {'key0' => 'value0', 'key1' => 'value1'}
    end
    describe 'w result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [13, 55] }
        Person.should_receive(:name_last_where_id_by_name_last).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.people @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [] }
        Person.should_not_receive(:name_last_where_id_by_name_last)
      end
      it { expect(@o.people @params).to eql [] }
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
