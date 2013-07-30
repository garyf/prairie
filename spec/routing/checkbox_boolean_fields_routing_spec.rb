require 'spec_helper'

describe CheckboxBooleanFieldsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/checkbox_boolean_fields/1/edit').to route_to('checkbox_boolean_fields#edit', id: '1')
    end
    it '#update' do
      expect(put: '/checkbox_boolean_fields/1').to route_to('checkbox_boolean_fields#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/checkbox_boolean_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/checkbox_boolean_fields/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/checkbox_boolean_fields/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/checkbox_boolean_fields').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/checkbox_boolean_fields/1').not_to be_routable
    end
  end
end
