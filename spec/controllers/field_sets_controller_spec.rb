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

  context 'GET new' do
    context 'w kind recognized' do
      before { PersonFieldSet.should_receive(:new) { person_field_set_mk } }
      describe 'w #new_able?' do
        before do
          person_field_set_mk.should_receive(:new_able?) { true }
          get :new, kind: 'Person'
        end
        it do
          expect(assigns :field_set).to be @person_field_set_mock
          expect(response).to render_template :new
        end
      end

      describe 'w/o #new_able?' do
        before do
          person_field_set_mk.should_receive(:new_able?) { false }
          @person_field_set_mock.should_receive(:type_human).with(true) { 'person field set' }
          get :new, kind: 'Person'
        end
        it do
          expect(flash[:alert]).to match /Quantity limit reached for person field sets/
          expect(response).to redirect_to root_path
        end
      end
    end

    it 'w/o kind recognized' do
      expect{ get :new, kind: 'Thing' }.to raise_error(FieldSet::SubklassNotRecognized)
    end
  end

  context 'POST create' do
    context 'w #new_able?' do
      describe 'w #save' do
        before do
          PersonFieldSet.should_receive(:new).with(valid_attributes) { person_field_set_mk(new_able?: true, save: true) }
          person_field_set_mk.should_receive(:type_human) { 'Person field set' }
          post :create, field_set: valid_attributes.merge('some' => 'attribute')
        end
        it do
          expect(assigns :field_set).to be @person_field_set_mock
          expect(flash[:notice]).to match /Person field set successfully created/i
          expect(response).to redirect_to field_sets_path
        end
      end

      describe 'w/o #save' do
        before do
          PersonFieldSet.should_receive(:new).with(valid_attributes) { person_field_set_mk(new_able?: true, save: false) }
          person_field_set_mk.should_receive(:type_human).with(true) { 'person field set' }
          post :create, field_set: valid_attributes.merge('some' => 'attribute')
        end
        it do
          expect(flash[:alert]).to match /Failed to create person field set/i
          expect(response).to render_template :new
        end
      end
    end

    it 'w/o type recognized' do
      expect{ post :create, field_set: valid_attributes.merge('type' => 'ThingFieldSet') }.to raise_error(FieldSet::SubklassNotRecognized)
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
        @person_field_set_mock.should_receive(:type_human) { 'Person field set' }
        put :update, id: '21', field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(flash[:notice]).to match /Person field set successfully updated/i
        expect(response).to redirect_to field_sets_path
      end
    end

    describe 'w/o #update' do
      before do
        FieldSet.should_receive(:find).with('21') { person_field_set_mk }
        person_field_set_mk.should_receive(:update).with(valid_attributes) { false }
        @person_field_set_mock.should_receive(:type_human).with(true) { 'person field set' }
        put :update, id: '21', field_set: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(flash[:alert]).to match /Failed to update person field set/i
        expect(response).to render_template :edit
      end
    end
  end

  context 'DELETE destroy' do
    describe 'w #destroyable?' do
      before do
        FieldSet.should_receive(:find).with('21') { person_field_set_mk(destroyable?: true) }
        person_field_set_mk.should_receive(:destroy)
        @person_field_set_mock.should_receive(:type_human) { 'Person field set' }
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(flash[:notice]).to match /Person field set successfully destroyed/i
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
