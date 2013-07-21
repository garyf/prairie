require 'spec_helper'

describe SetupStringFieldsController do
  describe 'w routing to' do
    it '#new' do
      expect(get: '/setup_string_fields/new').to route_to('setup_string_fields#new')
    end
    it '#edit' do
      expect(get: '/setup_string_fields/1/edit').to route_to('setup_string_fields#edit', id: '1')
    end
    it '#create' do
      expect(post: '/setup_string_fields').to route_to('setup_string_fields#create')
    end
    it '#update' do
      expect(put: '/setup_string_fields/1').to route_to('setup_string_fields#update', id: '1')
    end
    it '#destroy' do
      expect(delete: '/setup_string_fields/1').to route_to('setup_string_fields#destroy', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/setup_string_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/setup_string_fields/1').not_to be_routable
    end
  end
end
