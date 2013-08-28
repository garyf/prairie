require 'spec_helper'

describe LocationSearchesController do
  context 'GET index' do
    context 'w key' do
      before { session[:location_search_key] = 'redis_key' }
      describe 'w params[:page]' do
        before do
          LocationSearch.should_receive(:locations_fetch).with('redis_key', '1') { ['o1','o2'] }
          get :index, page: '1'
        end
        it do
          expect(assigns :locations).to eql ['o1','o2']
          expect(response).to render_template :index
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
        expect(assigns :locations).to eql []
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
