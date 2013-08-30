require 'spec_helper'

describe PersonSearch do
  context '::result_ids_fetch', :redis do
    before do
      bld
      @params = {'these' => 'params'}
      @result_ids = %w{ 1 3 5 7 9 11 13 15 17 }
      @o.should_receive(:result_ids_by_relevance).with(@params) { @result_ids }
      @key = @o.result_ids_store(nil, @params)
    end
    it { expect(@key).to match /^person:search:ids:[0-9a-f]{16}$/ }

    describe 'w per_page == 3' do
      before { stub_const("Search::RESULTS_PER_PAGE", 3) }
      it { expect(PersonSearch.result_ids_fetch @key, 1).to eql %w{ 1 3 5 } }
      it { expect(PersonSearch.result_ids_fetch @key, 2).to eql %w{ 7 9 11 } }
      it { expect(PersonSearch.result_ids_fetch @key, 3).to eql %w{ 13 15 17 } }
    end

    describe 'w per_page == 4' do
      before { stub_const("Search::RESULTS_PER_PAGE", 4) }
      it { expect(PersonSearch.result_ids_fetch @key, 1).to eql %w{ 1 3 5 7 } }
      it { expect(PersonSearch.result_ids_fetch @key, 2).to eql %w{ 9 11 13 15 } }
      it { expect(PersonSearch.result_ids_fetch @key, 3).to eql %w{ 17 } }
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
