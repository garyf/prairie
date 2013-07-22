require 'spec_helper'

describe LocationsController do
  describe 'GET index' do
    before do
      Location.should_receive(:by_name).with('2') { ['o1','o2','o3'] }
      get :index, page: '2'
    end
    it do
      expect(assigns :locations).to eql ['o1','o2','o3']
      expect(response).to render_template :index
    end
  end

  describe 'GET new' do
    before do
      Location.should_receive(:new) { location_mk }
      get :new
    end
    it do
      expect(assigns :location).to be @location_mock
      expect(response).to render_template :new
    end
  end

  context 'POST create' do
    describe 'w #save' do
      before do
        Location.should_receive(:new).with(valid_attributes) { location_mk(save: true) }
        post :create, location: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :location).to be @location_mock
        expect(flash[:notice]).to match /Location successfully created/i
        expect(response).to redirect_to @location_mock
      end
    end

    describe 'w/o #save' do
      before do
        with_errors_double
        Location.should_receive(:new).with(valid_attributes) { location_mk(save: false, errors: @errors) }
        post :create, location: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :new }
    end
  end

  context 'w @location' do
    before { Location.should_receive(:find).with('21') { location_mk } }

    describe 'GET show' do
      before do
        LocationFieldSet.should_receive(:by_name) { ['s1','s2'] }
        get :show, id: '21'
      end
      it do
        expect(assigns :location).to be @location_mock
        expect(assigns :field_sets).to eql ['s1','s2']
        expect(response).to render_template :show
      end
    end

    describe 'GET edit' do
      before { get :edit, id: '21' }
      it do
        expect(assigns :location).to be @location_mock
        expect(response).to render_template :edit
      end
    end

    describe 'DELETE destroy' do
      before do
        location_mk.should_receive(:destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :location).to be @location_mock
        expect(flash[:notice]).to match /Location successfully destroyed/i
        expect(response).to redirect_to locations_path
      end
    end
  end

  context 'PUT update' do
    describe 'w #update' do
      before do
        Location.should_receive(:find).with('21') { location_mk }
        location_mk.should_receive(:update).with(valid_attributes) { true }
        put :update, id: '21', location: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :location).to be @location_mock
        expect(flash[:notice]).to match /Location successfully updated/i
        expect(response).to redirect_to @location_mock
      end
    end

    describe 'w/o #update' do
      before do
        with_errors_double
        Location.should_receive(:find).with('21') { location_mk(errors: @errors) }
        location_mk.should_receive(:update).with(valid_attributes) { false }
        put :update, id: '21', location: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :edit }
    end
  end

private

  def valid_attributes() {
    'description' => 'edge city in Northern Virginia',
    'name' => 'Tysons Corner'}
  end
end
