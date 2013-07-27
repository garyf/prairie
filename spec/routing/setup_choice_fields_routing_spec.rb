require 'spec_helper'

describe SetupChoiceFieldsController do
  describe 'w routing to' do
    it '#show' do
      expect(get: '/setup_choice_fields/1').to route_to('setup_choice_fields#show', id: '1')
    end
    it '#new' do
      expect(get: '/setup_choice_fields/new').to route_to('setup_choice_fields#new')
    end
    it '#edit' do
      expect(get: '/setup_choice_fields/1/edit').to route_to('setup_choice_fields#edit', id: '1')
    end
    it '#create' do
      expect(post: '/setup_choice_fields').to route_to('setup_choice_fields#create')
    end
    it '#update' do
      expect(put: '/setup_choice_fields/1').to route_to('setup_choice_fields#update', id: '1')
    end
    it '#destroy' do
      expect(delete: '/setup_choice_fields/1').to route_to('setup_choice_fields#destroy', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#index' do
      expect(get: '/setup_choice_fields').not_to be_routable
    end
  end
end
