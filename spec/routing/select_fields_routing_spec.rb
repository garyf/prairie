require 'spec_helper'

describe SelectFieldsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/select_fields/1/edit').to route_to('select_fields#edit', id: '1')
    end
    it '#update' do
      expect(put: '/select_fields/1').to route_to('select_fields#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/select_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/select_fields/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/select_fields/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/select_fields').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/select_fields/1').not_to be_routable
    end
  end
end
