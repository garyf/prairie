require 'spec_helper'

describe LocationSearch do
  context '::result_ids_fetch', :redis do
    before do
      bld
      @params = {'these' => 'params'}
      @result_ids = %w{ 2 4 6 8 10 12 14 16 18 }
      @o.should_receive(:result_ids_by_relevance).with(@params) { @result_ids }
      @key = @o.result_ids_store(nil, @params)
    end
    it { expect(@key).to match /^location:search:ids:[0-9a-f]{16}$/ }

    describe 'w per_page == 3' do
      before { stub_const("Search::RESULTS_PER_PAGE", 3) }
      it { expect(LocationSearch.result_ids_fetch @key, 1).to eql %w{ 2 4 6 } }
      it { expect(LocationSearch.result_ids_fetch @key, 2).to eql %w{ 8 10 12 } }
      it { expect(LocationSearch.result_ids_fetch @key, 3).to eql %w{ 14 16 18 } }
    end

    describe 'w per_page == 4' do
      before { stub_const("Search::RESULTS_PER_PAGE", 4) }
      it { expect(LocationSearch.result_ids_fetch @key, 1).to eql %w{ 2 4 6 8 } }
      it { expect(LocationSearch.result_ids_fetch @key, 2).to eql %w{ 10 12 14 16 } }
      it { expect(LocationSearch.result_ids_fetch @key, 3).to eql %w{ 18 } }
    end
  end

private

  def bld
    @o = LocationSearch.new
  end
end
