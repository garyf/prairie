require 'spec_helper'

describe LocationSearch do
  context '#result_ids_store' do
    before do
      bld
      @params0 = {'this' => 'foo'}
    end
    context 'w result_ids', :redis do
      before do
        @result_ids0 = %w{ 1 3 5 7 9 11 13 15 }
        @o.should_receive(:result_ids_by_relevance).with(@params0) { @result_ids0 }
        @key0 = @o.result_ids_store(nil, @params0)
        @search_cache0 = SearchCache.new(@key0)
        stub_const("SearchCache::RESULTS_PER_PAGE", 3)
      end
      it do
        expect(@key0).to match /^location:search:ids:[0-9a-f]{16}$/
        expect(@search_cache0.result_ids_count).to eql 8
        expect(@search_cache0.result_ids_fetch 1).to eql %w{ 1 3 5 }
      end

      describe 'a second search updates the cache' do
        before do
          @params1 = {'this' => 'bar'}
          @result_ids1 = %w{ 2 4 6 8 10 }
          @o.should_receive(:result_ids_by_relevance).with(@params1) { @result_ids1 }
          @key1 = @o.result_ids_store(@key0, @params1)
          @search_cache1 = SearchCache.new(@key1)
        end
        it do
          expect(@search_cache0.result_ids_count).to eql 0
          expect(@search_cache0.result_ids_fetch 1).to eql []
          expect(@key1).to match /^location:search:ids:[0-9a-f]{16}$/
          expect(@search_cache1.result_ids_count).to eql 5
          expect(@search_cache1.result_ids_fetch 1).to eql %w{ 2 4 6 }
        end
      end
    end

    describe 'w/o result_ids' do
      before { @o.should_receive(:result_ids_by_relevance).with(@params0) { [] } }
      it { expect(@o.result_ids_store nil, @params0).to be nil }
    end
  end

private

  def bld
    @o = LocationSearch.new
  end
end
