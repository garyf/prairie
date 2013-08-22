require 'spec_helper'

describe PersonSearchesController do
  describe 'GET index' do
    it do
      get :index
      expect(response).to redirect_to new_person_search_path
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
    before do
      PersonSearch.stub_chain(:new, :results_united).with({'controller' => 'person_searches', 'action' => 'create'}.merge(valid_params)) { ['p1','p2'] }
      post :create, valid_params
    end
    it do
      expect(assigns :people).to eql ['p1','p2']
      expect(response).to render_template :index
    end
  end

private

  def valid_params() {
    'name_last' => 'Dickens',
    'field_21_gist' => 'seal brown',
    'field_34_gist' => '144'}
  end
end
