require 'spec_helper'

describe LocationSearch do
  context '#locations' do
    before do
      bld
      @params = {'key0' => 'value0', 'key1' => 'value1', 'key2' => ''}
    end
    describe 'w result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [13, 55] }
        Location.should_receive(:name_where_id_by_name).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.locations @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [] }
        Location.should_not_receive(:name_where_id_by_name)
      end
      it { expect(@o.locations @params).to eql [] }
    end
  end

private

  def bld
    @o = LocationSearch.new
  end
end
