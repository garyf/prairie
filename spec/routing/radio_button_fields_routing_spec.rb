require 'spec_helper'

describe RadioButtonFieldsController do
  describe 'w routing to' do
    it '#edit' do
      expect(get: '/radio_button_fields/1/edit').to route_to('radio_button_fields#edit', id: '1')
    end
    it '#update' do
      expect(put: '/radio_button_fields/1').to route_to('radio_button_fields#update', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/radio_button_fields').not_to be_routable
    end
    it '#show' do
      expect(get: '/radio_button_fields/1').not_to be_routable
    end
    it '#new' do
      expect(get: '/radio_button_fields/new').not_to be_routable
    end
    it '#create' do
      expect(post: '/radio_button_fields').not_to be_routable
    end
    it '#destroy' do
      expect(delete: '/radio_button_fields/1').not_to be_routable
    end
  end
end
