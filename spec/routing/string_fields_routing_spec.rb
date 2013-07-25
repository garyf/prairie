require 'spec_helper'

describe StringFieldsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/string_fields/1/edit').to route_to('string_fields#edit', id: '1')
    end
    it '#update' do
      expect(put: '/string_fields/1').to route_to('string_fields#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/string_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/string_fields/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/string_fields/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/string_fields').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/string_fields/1').not_to be_routable
    end
  end
end
