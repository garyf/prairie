require 'spec_helper'

describe LocationSearch do
  context '#column_all_gather_ids, #column_any_gather_ids' do
    before do
      @location0 = c_location_cr(name: 'Annapolis', description: 'seaport')
      @location1 = c_location_cr(name: 'Baltimore', description: 'industrial')
      @location2 = c_location_cr(name: 'Camden', description: 'seaport')
      bld
    end
    describe 'w/o any columns_w_values' do
      before do
        @params = {
          'description' => '',
          'name' => ''}
      end
      it { expect(@o.column_all_gather_ids @params).to be nil }
      it { expect(@o.column_any_gather_ids @params).to eql [] }
    end

    context 'w 1 search term' do
      describe 'w/o any matching' do
        before do
          @params = {
            'description' => '',
            'name' => 'Denver'}
        end
        it { expect(@o.column_all_gather_ids @params).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before do
          @params = {
            'description' => '',
            'name' => 'Annapolis'}
        end
        it { expect(@o.column_all_gather_ids @params).to eql [@location0.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@location0.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w 1 all_agree parent' do
        before do
          @params = {
            'description' => 'seaport',
            'name' => 'Camden'}
        end
        it { expect(@o.column_all_gather_ids @params). to eql [@location2.id] }
        it 'note multiple appearances of @location2' do
          expect(@o.column_any_gather_ids @params).to match_array [@location0.id, @location2.id, @location2.id]
        end
      end

      describe 'w/o any all_agree parents' do
        before do
          @params = {
            'description' => 'seaport',
            'name' => 'Baltimore'}
        end
        it { expect(@o.column_all_gather_ids @params).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to match_array [@location0.id, @location1.id, @location2.id] }
      end

      describe 'w/o matching term' do
        before do
          @params = {
            'description' => 'wherever',
            'name' => 'Denver'}
        end
        it { expect(@o.column_all_gather_ids @params).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end
    end
  end

  context '#column_substring_gather_ids' do
    before do
      @location0 = c_location_cr(name: 'Annapolis', description: 'seaport')
      @location1 = c_location_cr(name: 'Baltimore', description: 'industrial')
      @location2 = c_location_cr(name: 'Camden', description: 'seaport')
      bld
    end
    describe 'w/o any columns_w_substring_values' do
      before do
        @params = {
          'description' => 'se',
          'name' => 'An'}
      end
      it { expect(@o.column_substring_gather_ids @params).to be nil }
    end

    context 'w 1 search term' do
      describe 'w/o any matching' do
        before do
          @params = {
            'description' => '',
            'name' => 'Anm'}
        end
        it { expect(@o.column_substring_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before do
          @params = {
            'description' => '',
            'name' => 'Ann'}
        end
        it { expect(@o.column_substring_gather_ids @params).to eql [@location0.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w both substrings by 1 parent' do
        before do
          @params = {
            'description' => 'apo',
            'name' => 'amd'}
        end
        it { expect(@o.column_substring_gather_ids @params). to match_array [@location2.id, @location2.id, @location0.id] }
      end

      describe 'w 1 substring by 1 parent' do
        before do
          @params = {
            'description' => 'ndu',
            'name' => 'Denver'}
        end
        it { expect(@o.column_substring_gather_ids @params). to eql [@location1.id] }
      end

      describe 'w/o matching term' do
        before do
          @params = {
            'description' => 'wherever',
            'name' => 'Denver'}
        end
        it { expect(@o.column_substring_gather_ids @params).to eql [] }
      end
    end
  end

private

  def bld
    @o = LocationSearch.new
  end
end
