require 'spec_helper'

describe LocationSearchesController do
  context 'GET index' do
    context 'w key' do
      before { session[:location_search_key] = 'redis_key' }
      context 'w params[:page]' do
        before do
          @search_cache = double('search_cache')
          SearchCache.should_receive(:new).with('redis_key') { @search_cache }
        end
        describe 'w/o @locations.empty?' do
          before do
            Location.should_receive(:search_results_fetch).with(@search_cache, '1') { ['o1','o2'] }
            @search_cache.should_receive(:result_ids_count) { 2 }
            get :index, page: '1'
          end
          it do
            expect(assigns :search_results_for_page).to eql ['o1','o2']
            expect(assigns :results_count).to eql 2
            expect(response).to render_template :index
          end
        end

        describe 'w @locations.empty?' do
          before do
            Location.should_receive(:search_results_fetch).with(@search_cache, '1') { [] }
            @search_cache.should_not_receive(:result_ids_count) { 0 }
            get :index, page: '1'
          end
          it do
            expect(assigns :search_results_for_page).to eql []
            expect(response).to redirect_to new_location_search_path
          end
        end
      end

      describe 'w/o params[:page]' do
        before do
          LocationSearch.should_not_receive(:locations_fetch)
          get :index
        end
        it { expect(response).to redirect_to new_location_search_path }
      end
    end

    describe 'w/o key' do
      before do
        session[:location_search_key] = nil
        LocationSearch.should_not_receive(:locations_fetch)
        get :index, page: '1'
      end
      it { expect(response).to redirect_to new_location_search_path }
    end
  end

  describe 'GET new' do
    before do
      LocationFieldSet.should_receive(:by_name) { ['s1','s2'] }
      get :new
    end
    it do
      expect(assigns :field_sets).to eql ['s1','s2']
      expect(response).to render_template :new
    end
  end

  context 'POST create' do
    before { session[:location_search_key] = 'old_key' }
    describe 'w #result_ids_store' do
      before do
        LocationSearch.stub_chain(:new, :result_ids_store).with(
          'old_key',
          {'controller' => 'location_searches', 'action' => 'create'}.merge(valid_params)) { 'redis_key' }
        post :create, valid_params
      end
      it do
        expect(session[:location_search_key]).to eql 'redis_key'
        expect(response).to redirect_to location_searches_path(page: '1')
      end
    end

    describe 'w/o #result_ids_store' do
      before do
        LocationSearch.stub_chain(:new, :result_ids_store).with(
          'old_key',
          {'controller' => 'location_searches', 'action' => 'create'}.merge(valid_params)) { nil }
        post :create, valid_params
      end
      it do
        expect(session[:location_search_key]).to be nil
        expect(assigns :search_results_for_page).to eql []
        expect(response).to render_template :index
      end
    end
  end

private

  def valid_params() {
    'name' => 'Oxford',
    'field_21_gist' => 'seal brown',
    'field_34_gist' => '144'}
  end
end
