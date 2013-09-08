require 'spec_helper'

describe SearchHelper do
  context '#search_results_count' do
    it 'w @results_count == nil' do
      assign(:results_count, nil)
      expect(helper.search_results_count).to eql 'Search results'
    end
    it 'w @results_count == 0' do
      assign(:results_count, 0)
      expect(helper.search_results_count).to eql 'Search results'
    end
    it 'w @results_count == 1' do
      assign(:results_count, 1)
      expect(helper.search_results_count).to eql '1 search result'
    end
    it 'w @results_count > 1' do
      assign(:results_count, 2)
      expect(helper.search_results_count).to eql '2 search results'
    end
  end

  context '#search_results_info' do
    before { @params_core = {action: 'index', controller: 'location_searches'} }
    describe  do
      it 'w @results_count == 1' do
        expect(search_results_info 1, @params_core.merge(page: 1)).to eql '1 location found'
      end
      it 'w @results_count == 2' do
        expect(search_results_info 2, @params_core.merge(page: 1)).to eql 'All 2 locations found'
      end
      context 'w @results_count == 11' do
        it { expect(search_results_info 11, @params_core.merge(page: 1)).to eql 'Locations 1 - 11' }
        it { expect(search_results_info 11, @params_core.merge(page: 2)).to eql 'Locations 11 - 11' }
      end
    end
  end
end
