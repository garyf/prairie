require 'spec_helper'

describe LocationSearch do
  context '#column_find_ids' do
    describe 'w/o a search term' do
      before { bld }
      it { expect(@o.column_find_ids({'name' => ''})).to be nil }
    end

    context 'w 3 locations' do
      before do
        @location0 = c_location_cr(name: 'Annapolis', description: 'capital')
        @location1 = c_location_cr(name: 'Baltimore', description: 'industrial')
        @location2 = c_location_cr(name: 'Camden', description: 'seaport')
        bld
      end
      context 'w 1 search term' do
        it 'w matching term' do
          expect(@o.column_find_ids({'name' => 'Annapolis'})).to match_array [@location0.id]
          expect(@o.column_find_ids({'name' => 'Annapolis'}, true)).to match_array [@location0.id]
        end
        it 'w/o matching term' do
          expect(@o.column_find_ids({'name' => 'bar'})).to eql []
          expect(@o.column_find_ids({'name' => 'bar'}, true)).to eql []
        end
      end

      context 'w 2 search terms' do
        describe 'w 2 matching terms' do
          before do
            @params = {
              'name' => 'Annapolis',
              'description' => 'seaport'}
          end
          it { expect(@o.column_find_ids @params). to eql [] }
          it { expect(@o.column_find_ids @params, true). to match_array [@location0.id, @location2.id] }
        end

        describe 'w 1 matching term' do
          before do
            @params = {
              'name' => 'Baltimore',
              'description' => 'wherever'}
          end
          it { expect(@o.column_find_ids @params).to match_array [] }
          it { expect(@o.column_find_ids @params, true).to match_array [@location1.id] }
        end

        describe 'w/o matching term' do
          before do
            @params = {
              'name' => 'City',
              'description' => 'wherever'}
          end
          it { expect(@o.column_find_ids @params).to eql [] }
          it { expect(@o.column_find_ids @params, true).to eql [] }
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
        @o.should_receive(:all_agree_find_ids).with(@params) { [13, 55] }
        Location.should_receive(:name_where_id_by_name).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.locations @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:all_agree_find_ids).with(@params) { [] }
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
