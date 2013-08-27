require 'spec_helper'

describe LocationSearchesController do
  describe 'GET index' do
    it do
      get :index
      expect(response).to redirect_to new_location_search_path
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

  describe 'POST create' do
    before do
      LocationSearch.stub_chain(:new, :results_find).with({'controller' => 'location_searches', 'action' => 'create'}.merge(valid_params)) { ['o1','o2'] }
      post :create, valid_params
    end
    it do
      expect(assigns :locations).to eql ['o1','o2']
      expect(response).to render_template :index
    end
  end

private

  def valid_params() {
    'name' => 'Oxford',
    'field_21_gist' => 'seal brown',
    'field_34_gist' => '144'}
  end
end
