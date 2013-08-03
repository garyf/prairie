require 'spec_helper'

describe LocationSearchesController do
  describe 'w routing to' do
    it '#index' do
      expect(get: '/location_searches').to route_to('location_searches#index')
    end
    it '#new' do
      expect(get: '/location_searches/new').to route_to('location_searches#new')
    end
    it '#create' do
      expect(post: '/location_searches').to route_to('location_searches#create')
    end
  end

  describe 'w/o routing to' do
    it '#show' do
      expect(get: '/location_searches/1').not_to be_routable
    end
    it '#edit' do
      expect(get: '/location_searches/1/edit').not_to be_routable
    end
    it '#update' do
      expect(put: '/location_searches/1').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/location_searches/1').not_to be_routable
    end
  end
end
