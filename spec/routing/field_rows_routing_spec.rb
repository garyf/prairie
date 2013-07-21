require "spec_helper"

describe FieldRowsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/field_rows/1/edit').to route_to('field_rows#edit', id: '1')
    end
    it '#update' do
      expect(put: '/field_rows/1').to route_to('field_rows#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/field_rows').not_to be_routable
    end
    it '#show' do
      expect(get: '/field_rows/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/field_rows/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/field_rows').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/field_rows/1').not_to be_routable
    end
  end
end
