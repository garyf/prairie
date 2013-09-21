require 'spec_helper'

describe Person do
  describe '::search_results_fetch' do
    before do
      @search_cache = double('search_cache')
      result_ids = %w{ 2 3 5 }
      @people = %w{ p2 p3 p5 }
      @search_cache.should_receive(:result_ids_fetch).with('1') { result_ids }
      Person.should_receive(:name_last_where_ids_preserve_order).with(result_ids) { @people }
    end
    it { expect(Person.search_results_fetch @search_cache, '1').to eql @people }
  end
end
