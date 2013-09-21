require 'spec_helper'

describe Location do
  describe '::search_results_fetch' do
    before do
      @search_cache = double('search_cache')
      result_ids = %w{ 2 3 5 }
      @locations = %w{ p2 p3 p5 }
      @search_cache.should_receive(:result_ids_fetch).with('1') { result_ids }
      Location.should_receive(:name_where_ids_preserve_order).with(result_ids) { @locations }
    end
    it { expect(Location.search_results_fetch @search_cache, '1').to eql @locations }
  end
end
