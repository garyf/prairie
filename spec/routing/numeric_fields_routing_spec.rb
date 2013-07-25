require 'spec_helper'

describe NumericFieldsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/numeric_fields/1/edit').to route_to('numeric_fields#edit', id: '1')
    end
    it '#update' do
      expect(put: '/numeric_fields/1').to route_to('numeric_fields#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/numeric_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/numeric_fields/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/numeric_fields/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/numeric_fields').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/numeric_fields/1').not_to be_routable
    end
  end
end
