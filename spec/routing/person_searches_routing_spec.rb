require 'spec_helper'

describe PersonSearchesController do
  describe 'w routing to' do
    it '#index' do
      expect(get: '/person_searches').to route_to('person_searches#index')
    end
    it '#new' do
      expect(get: '/person_searches/new').to route_to('person_searches#new')
    end
    it '#create' do
      expect(post: '/person_searches').to route_to('person_searches#create')
    end
  end

  describe 'w/o routing to' do
    it '#show' do
      expect(get: '/person_searches/1').not_to be_routable
    end
    it '#edit' do
      expect(get: '/person_searches/1/edit').not_to be_routable
    end
    it '#update' do
      expect(put: '/person_searches/1').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/person_searches/1').not_to be_routable
    end
  end
end
