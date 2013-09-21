require 'spec_helper'

describe SearchCache do
  context 'w result_ids_store#', :redis do
    before do
      person_search_bld
      params = {'these' => 'params'}
      @result_ids = %w{ 1 3 5 7 9 11 13 15 17 }
      @person_search.should_receive(:result_ids_by_relevance).with(params) { @result_ids }
      @key = @person_search.result_ids_store(nil, params)
    end
    it { expect(@key).to match /^person:search:ids:[0-9a-f]{16}$/ }

    context '#result_ids_fetch' do
      before { @o = SearchCache.new(@key) }
      it { expect(@o.result_ids_count).to eql 9 }

      describe 'w per_page == 3' do
        before { stub_const("SearchCache::RESULTS_PER_PAGE", 3) }
        it { expect(@o.result_ids_fetch 1).to eql %w{ 1 3 5 } }
        it { expect(@o.result_ids_fetch 2).to eql %w{ 7 9 11 } }
        it { expect(@o.result_ids_fetch 3).to eql %w{ 13 15 17 } }
      end

      describe 'w per_page == 4' do
        before { stub_const("SearchCache::RESULTS_PER_PAGE", 4) }
        it { expect(@o.result_ids_fetch 1).to eql %w{ 1 3 5 7 } }
        it { expect(@o.result_ids_fetch 2).to eql %w{ 9 11 13 15 } }
        it { expect(@o.result_ids_fetch 3).to eql %w{ 17 } }
      end
    end
  end

private

  def person_search_bld
    @person_search = PersonSearch.new
  end
end
