require "spec_helper"

describe EducationLevelsController do
  describe 'w routing to' do
    it '#index' do
      expect(get: '/education_levels').to route_to('education_levels#index')
    end
    it '#new' do
      expect(get: '/education_levels/new').to route_to('education_levels#new')
    end
    it '#edit' do
      expect(get: '/education_levels/1/edit').to route_to('education_levels#edit', id: '1')
    end
    it '#create' do
      expect(post: '/education_levels').to route_to('education_levels#create')
    end
    it '#update' do
      expect(put: '/education_levels/1').to route_to('education_levels#update', id: '1')
    end
    it '#destroy' do
      expect(delete: '/education_levels/1').to route_to('education_levels#destroy', id: '1')
    end
  end

  describe 'w/o routing to' do
    it '#show' do
      expect(get: '/education_levels/1').not_to be_routable
    end
  end
end
