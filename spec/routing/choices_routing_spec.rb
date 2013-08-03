require 'spec_helper'

describe ChoicesController do
  describe 'w routing to' do
    it '#new' do
      expect(get: '/choices/new').to route_to('choices#new')
    end
    it '#edit' do
      expect(get: '/choices/1/edit').to route_to('choices#edit', id: '1')
    end
    it '#create' do
      expect(post: '/choices').to route_to('choices#create')
    end
    it '#update' do
      expect(put: '/choices/1').to route_to('choices#update', id: '1')
    end
    it '#destroy' do
      expect(delete: '/choices/1').to route_to('choices#destroy', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/choices').not_to be_routable
    end
    it '#show' do
      expect(get: '/choices/1').not_to be_routable
    end
  end
end
