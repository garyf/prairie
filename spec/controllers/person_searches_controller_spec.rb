require 'spec_helper'

describe PersonSearchesController do
  context 'GET index' do
    context 'w key' do
      before { session[:person_search_key] = 'redis_key' }
      context 'w params[:page]' do
        before do
          @search_cache = double('search_cache')
          SearchCache.should_receive(:new).with('redis_key') { @search_cache }
        end
        describe 'w/o @people.empty?' do
          before do
            Person.should_receive(:search_results_fetch).with(@search_cache, '1') { ['o1','o2'] }
            @search_cache.should_receive(:result_ids_count) { 2 }
            get :index, page: '1'
          end
          it do
            expect(assigns :people).to eql ['o1','o2']
            expect(assigns :results_count).to eql 2
            expect(response).to render_template :index
          end
        end

        describe 'w @people.empty?' do
          before do
            Person.should_receive(:search_results_fetch).with(@search_cache, '1') { [] }
            @search_cache.should_not_receive(:result_ids_count) { 0 }
            get :index, page: '1'
          end
          it do
            expect(assigns :people).to eql []
            expect(response).to redirect_to new_person_search_path
          end
        end
      end

      describe 'w/o params[:page]' do
        before do
          PersonSearch.should_not_receive(:people_fetch)
          get :index
        end
        it { expect(response).to redirect_to new_person_search_path }
      end
    end

    describe 'w/o key' do
      before do
        session[:person_search_key] = nil
        PersonSearch.should_not_receive(:people_fetch)
        get :index, page: '1'
      end
      it { expect(response).to redirect_to new_person_search_path }
    end
  end

  describe 'GET new' do
    before do
      PersonFieldSet.should_receive(:by_name) { ['s1','s2'] }
      get :new
    end
    it do
      expect(assigns :field_sets).to eql ['s1','s2']
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    before { session[:person_search_key] = 'old_key' }
    describe 'w #result_ids_store' do
      before do
        PersonSearch.stub_chain(:new, :result_ids_store).with(
          'old_key',
          {'controller' => 'person_searches', 'action' => 'create'}.merge(valid_params)) { 'redis_key' }
        post :create, valid_params
      end
      it do
        expect(session[:person_search_key]).to eql 'redis_key'
        expect(response).to redirect_to person_searches_path(page: '1')
      end
    end

    describe 'w/o #result_ids_store' do
      before do
        PersonSearch.stub_chain(:new, :result_ids_store).with(
          'old_key',
          {'controller' => 'person_searches', 'action' => 'create'}.merge(valid_params)) { nil }
        post :create, valid_params
      end
      it do
        expect(session[:person_search_key]).to be nil
        expect(assigns :people).to eql []
        expect(response).to render_template :index
      end
    end
  end

private

  def valid_params() {
    'name_last' => 'Dickens',
    'field_21_gist' => 'seal brown',
    'field_34_gist' => '144'}
  end
end
