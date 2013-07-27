require 'spec_helper'

describe FieldSetsController do
  describe 'GET index' do
    before do
      FieldSet.should_receive(:by_name) { ['o1','o2','o3'] }
      get :index
    end
    it do
      expect(assigns :field_sets).to eql ['o1','o2','o3']
      expect(response).to render_template :index
    end
  end

  describe 'GET new' do
    before do
      PersonFieldSet.should_receive(:new) { person_field_set_mk }
      get :new, kind: 'Person'
    end
    it do
      expect(assigns :field_set).to be @person_field_set_mock
      expect(response).to render_template :new
    end
  end

  context 'POST create' do
    describe 'w #save' do
      before do
        PersonFieldSet.should_receive(:new).with(valid_attributes) { person_field_set_mk(save: true) }
        post :create, field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(flash[:notice]).to match /Field set successfully created/i
        expect(response).to redirect_to field_sets_path
      end
    end

    describe 'w/o #save' do
      before do
        with_errors_double
        PersonFieldSet.should_receive(:new).with(valid_attributes) { person_field_set_mk(save: false, errors: @errors) }
        post :create, field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(flash[:alert]).to match /Failed to create field set/i
        expect(response).to render_template :new
      end
    end
  end

  context 'w @person_field_set' do
    before { FieldSet.should_receive(:find).with('21') { person_field_set_mk } }

    describe 'GET show' do
      before do
        person_field_set_mk.stub_chain(:custom_fields, :ranked_page).with('2') { ['f1','f2','f3'] }
        get :show, id: '21', page: '2'
      end
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(assigns :custom_fields).to eql ['f1','f2','f3']
        expect(assigns :row_offset).to eql 9
        expect(response).to render_template :show
      end
    end

    describe 'GET edit' do
      before { get :edit, id: '21' }
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(response).to render_template :edit
      end
    end
  end

  context 'PUT update' do
    describe 'w #update' do
      before do
        FieldSet.should_receive(:find).with('21') { person_field_set_mk }
        person_field_set_mk.should_receive(:update).with(valid_attributes) { true }
        put :update, id: '21', field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(flash[:notice]).to match /Field set successfully updated/i
        expect(response).to redirect_to field_sets_path
      end
    end

    describe 'w/o #update' do
      before do
        with_errors_double
        FieldSet.should_receive(:find).with('21') { person_field_set_mk(errors: @errors) }
        person_field_set_mk.should_receive(:update).with(valid_attributes) { false }
        put :update, id: '21', field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(flash[:alert]).to match /Failed to update field set/i
        expect(response).to render_template :edit
      end
    end
  end

  context 'DELETE destroy' do
    describe 'w #destroyable?' do
      before do
        FieldSet.should_receive(:find).with('21') { person_field_set_mk(destroyable?: true) }
        person_field_set_mk.should_receive(:destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(flash[:notice]).to match /Field set successfully destroyed/i
        expect(response).to redirect_to field_sets_path
      end
    end

    describe 'w/o #destroyable?' do
      before do
        FieldSet.should_receive(:find).with('21') { person_field_set_mk(destroyable?: false) }
        person_field_set_mk.should_not_receive(:destroy)
        delete :destroy, id: '21'
      end
      it { expect(response).to redirect_to root_path }
    end
  end

private

  def valid_attributes() {
    'description' => 'lorem ipsum',
    'name' => 'Friends',
    'type' => 'PersonFieldSet'}
  end
end
