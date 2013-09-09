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
    before { @params = {action: 'index', controller: 'location_searches'} }
    describe  do
      it 'w @results_count == 1' do
        expect(search_results_info 1, @params.merge(page: 1)).to eql '1 location found'
      end
      it 'w @results_count == 2' do
        expect(search_results_info 2, @params.merge(page: 1)).to eql 'All 2 locations found'
      end
      context 'w @results_count == 11' do
        it { expect(search_results_info 11, @params.merge(page: 1)).to eql 'Locations 1 - 10' }
        it { expect(search_results_info 11, @params.merge(page: 2)).to eql 'Locations 11 - 11' }
      end
    end
  end

  context '#search_pagination_nav' do
    before { @params = {action: 'index', controller: 'location_searches'} }
    describe  do
      it 'w 1 results page' do
        expect(search_pagination_nav 10, @params.merge(page: 1)).to eql []
      end
      context 'w 2 result pages' do
        describe 'w page 1' do
          subject { search_pagination_nav 11, @params.merge(page: 1) }
          it do
            expect(subject.length).to eql 2
            expect(subject[0]).to match /<li class=disabled><a href="#">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=2">Next<\/a><\/li>/
          end
        end

        describe 'w page 2' do
          subject { search_pagination_nav 11, @params.merge(page: 2) }
          it do
            expect(subject.length).to eql 2
            expect(subject[0]).to match /<li><a href="\/location_searches\?page=1">First<\/a><\/li>/
            expect(subject[1]).to match /<li class=disabled><a href="#">Last<\/a><\/li>/
          end
        end
      end

      context 'w 3 result pages' do
        describe 'w page 1' do
          subject { search_pagination_nav 21, @params.merge(page: 1) }
          it do
            expect(subject.length).to eql 2
            expect(subject[0]).to match /<li class=disabled><a href="#">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=2">Next<\/a><\/li>/
          end
        end

        describe 'w page 2' do
          subject { search_pagination_nav 21, @params.merge(page: 2) }
          it do
            expect(subject.length).to eql 2
            expect(subject[0]).to match /<li><a href="\/location_searches\?page=1">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=3">Next<\/a><\/li>/
          end
        end

        describe 'w page 3' do
          subject { search_pagination_nav 21, @params.merge(page: 3) }
          it do
            expect(subject.length).to eql 3
            expect(subject[0]).to match /<li><a href="\/location_searches\?page=1">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=2">Prev<\/a><\/li>/
            expect(subject[2]).to match /<li class=disabled><a href="#">Last<\/a><\/li>/
          end
        end
      end

      context 'w 4 result pages' do
        describe 'w page 3' do
          subject { search_pagination_nav 31, @params.merge(page: 3) }
          it do
            expect(subject.length).to eql 3
            expect(subject[0]).to match /<li><a href="\/location_searches\?page=1">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=2">Prev<\/a><\/li>/
            expect(subject[2]).to match /<li><a href="\/location_searches\?page=4">Next<\/a><\/li>/
          end
        end

        describe 'w page 4' do
          subject { search_pagination_nav 31, @params.merge(page: 4) }
          it do
            expect(subject.length).to eql 3
            expect(subject[0]).to match /<li><a href="\/location_searches\?page=1">First<\/a><\/li>/
            expect(subject[1]).to match /<li><a href="\/location_searches\?page=3">Prev<\/a><\/li>/
            expect(subject[2]).to match /<li class=disabled><a href="#">Last<\/a><\/li>/
          end
        end
      end
    end
  end
end
