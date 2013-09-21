require 'spec_helper'

describe LocationSearch do
  context '#column_gather_ids w/o near_p, #column_any_gather_ids' do
    before do
      @location0 = c_location_cr(name: 'Annapolis', description: 'seaport', lot_acres: 800, public_p: true)
      @location1 = c_location_cr(name: 'Baltimore', description: 'industrial', lot_acres: 1400, public_p: false)
      @location2 = c_location_cr(name: 'Camden', description: 'seaport', lot_acres: 2100, public_p: true)
      bld
      @params_blank = {
        'name' => '',
        'description' => '',
        'lot_acres' => ''}
    end
    describe 'w/o any columns_w_values' do
      it { expect(@o.column_gather_ids @params_blank, false).to be nil }
      it { expect(@o.column_any_gather_ids @params_blank).to eql [] }
    end

    context 'w 1 string term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('name' => 'Denver') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('name' => 'Annapolis') }
        it { expect(@o.column_gather_ids @params, false).to eql [@location0.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@location0.id] }
      end
    end

    context 'w 1 numeric term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('lot_acres' => '500') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('lot_acres' => '1400') }
        it { expect(@o.column_gather_ids @params, false).to eql [@location1.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@location1.id] }
      end
    end

    context 'w 1 boolean term' do
      describe 'w 1 matching' do
        before { @params = @params_blank.merge('public_p' => '0') }
        it { expect(@o.column_gather_ids @params, false).to eql [@location1.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@location1.id] }
      end

      describe 'w 2 matching' do
        before { @params = @params_blank.merge('public_p' => '1') }
        it { expect(@o.column_gather_ids @params, false).to eql [@location0.id, @location2.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@location0.id, @location2.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w 1 all_agree parent' do
        before { @params = @params_blank.merge('description' => 'seaport', 'lot_acres' => '2100') }
        it { expect(@o.column_gather_ids @params, false). to eql [@location2.id] }
        it 'note multiple appearances of @location2' do
          expect(@o.column_any_gather_ids @params).to match_array [@location0.id, @location2.id, @location2.id]
        end
      end

      describe 'w/o any all_agree parents' do
        before { @params = @params_blank.merge('description' => 'seaport', 'name' => 'Baltimore') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to match_array [@location0.id, @location1.id, @location2.id] }
      end

      describe 'w/o matching term' do
        before { @params = @params_blank.merge('description' => 'wherever', 'name' => 'Denver') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end
    end
  end

  context '#column_gather_ids w near_p' do
    before do
      @location0 = c_location_cr(name: 'Annapolis', description: 'seaport', lot_acres: 800, public_p: true)
      @location1 = c_location_cr(name: 'Baltimore', description: 'industrial', lot_acres: 1400, public_p: false)
      @location2 = c_location_cr(name: 'Camden', description: 'seaport', lot_acres: 2100, public_p: true)
      bld
      @params_blank = {
        'name' => '',
        'description' => '',
        'lot_acres' => ''}
    end

    it 'w/o any #columns_w_near_values' do
      expect(@o.column_gather_ids @params_blank, true).to be nil
    end

    context 'w 1 string term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('name' => 'Anc') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('name' => 'Ann') }
        it { expect(@o.column_gather_ids @params, true).to eql [@location0.id] }
      end
    end

    context 'w 1 numeric term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('lot_acres' => '500') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('lot_acres' => '801') }
        it { expect(@o.column_gather_ids @params, true).to eql [@location0.id] }
      end
    end

    context 'w 1 boolean term' do
      describe 'w 1 matching' do
        before { @params = @params_blank.merge('public_p' => '0') }
        it { expect(@o.column_gather_ids @params, true).to be nil }
      end

      describe 'w 2 matching' do
        before { @params = @params_blank.merge('public_p' => '1') }
        it { expect(@o.column_gather_ids @params, true).to be nil }
      end
    end

    context 'w 2 search terms' do
      describe 'w both substrings by 1 parent' do
        before { @params = @params_blank.merge('description' => 'sea', 'lot_acres' => '2101') }
        it { expect(@o.column_gather_ids @params, true). to eql [@location2.id] }
      end

      describe 'w both substrings by different parents' do
        before { @params = @params_blank.merge('description' => 'ind', 'lot_acres' => '2101') }
        it { expect(@o.column_gather_ids @params, true). to eql [] }
      end

      describe 'w/o matching term' do
        before { @params = @params_blank.merge('description' => 'wherever', 'lot_acres' => '500') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end
    end
  end

private

  def bld
    @o = LocationSearch.new
  end
end
