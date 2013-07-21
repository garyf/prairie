require 'spec_helper'

describe FieldValuesController do
  describe 'w routing to' do
    it '#index' do
      expect(get: '/field_values').to route_to('field_values#index')
    end
  end

  describe 'w/o routing to' do
    it '#show' do
      expect(get: '/field_values/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/field_values/new').not_to be_routable
    end
    it '#edit' do
      expect(get: '/field_values/1/edit').not_to be_routable
    end
    it '#create' do
      expect(post: '/field_values').not_to be_routable
    end
    it '#update' do
      expect(put: '/field_values/1').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/field_values/1').not_to be_routable
    end
  end
end
