require 'spec_helper'

describe LocationSearch do
  context '#column_result_ids' do
    describe 'w/o a search term' do
      before { bld }
      it { expect(@o.column_result_ids({'name' => ''})).to be nil }
    end

    context 'w 2 locations' do
      before do
        @location0 = c_location_cr(name: 'Annapolis', description: 'city')
        @location1 = c_location_cr(name: 'annapolis', description: 'seaport')
        @location2 = c_location_cr(name: 'foo', description: 'bar')
        bld
      end
      context 'w 1 search term' do
        it 'w matching term' do
          expect(@o.column_result_ids({'name' => 'Annapolis'})).to match_array [@location0.id, @location1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_result_ids({'name' => 'bar'})).to eql []
        end
      end

      context 'w 2 search terms' do
        it 'w matching term' do
          expect(@o.column_result_ids({
            'name' => 'Annapolis',
            'description' => 'seaport'})).to match_array [@location1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_result_ids({
            'name' => 'Annapolis',
            'description' => 'bar'})).to eql []
        end
      end
    end
  end

  context '#locations' do
    before do
      bld
      @params = {'key0' => 'value0', 'key1' => 'value1', 'key2' => ''}
    end
    describe 'w result_ids' do
      before do
        @o.should_receive(:column_and_custom_ids).with(@params) { [13, 55] }
        Location.should_receive(:name_where_id_by_name).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.locations @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:column_and_custom_ids).with(@params) { [] }
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
