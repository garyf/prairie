require 'spec_helper'

describe SetupStringFieldsController do
  context 'w params[:field_set_id]' do
    before { FieldSet.should_receive(:find).with('55') { location_field_set_mk } }

    describe 'GET new' do
      before do
        location_field_set_mk.stub_chain(:string_fields, :new) { string_field_mk }
        get :new, field_set_id: '55'
      end
      it do
        expect(assigns :field_set).to be @location_field_set_mock
        expect(assigns :string_field).to be @string_field_mock
        expect(response).to render_template :new
      end
    end

    context 'POST create' do
      describe 'w #save' do
        before do
          location_field_set_mk.stub_chain(:string_fields, :new).with(valid_attributes) { string_field_mk(save: true) }
          string_field_mk.should_receive(:constraints_store).with(valid_attributes)
          post :create, string_field: valid_attributes.merge('some' => 'attribute')
        end
        it do
          expect(assigns :field_set).to be @location_field_set_mock
          expect(assigns :string_field).to be @string_field_mock
          expect(flash[:notice]).to match /String field successfully created/i
          expect(response).to redirect_to field_set_path(@location_field_set_mock)
        end
      end

      describe 'w/o #save' do
        before do
          with_errors_double
          location_field_set_mk.stub_chain(:string_fields, :new).with(valid_attributes) { string_field_mk(save: false) }
          string_field_mk.should_not_receive(:constraints_store)
          post :create, string_field: valid_attributes.merge('some' => 'attribute')
        end
        it do
          expect(flash[:alert]).to match /Failed to create string field/i
          expect(response).to render_template :new
        end
      end
    end
  end

  context 'w @string_field' do
    before do
      StringField.should_receive(:find).with('21') do
        string_field_mk(
          field_set: location_field_set_mk,
          parent?: true)
      end
    end

    describe 'GET edit' do
      before do
        string_field_mk.should_receive(:constraints_fetch)
        @string_field_mock.should_receive(:human_row)
        get :edit, id: '21'
      end
      it do
        expect(assigns :string_field).to be @string_field_mock
        expect(assigns :field_set).to be @location_field_set_mock
        expect(assigns :parent_p).to be true
        expect(response).to render_template :edit
      end
    end

    context 'PUT update' do
      describe 'w #update' do
        before do
          string_field_mk.should_receive(:update).with(valid_attributes_human) { true }
          @string_field_mock.should_receive(:constraints_store).with(valid_attributes)
          put :update, id: '21', string_field: valid_attributes.merge('some' => 'attribute')
        end
        it do
          expect(assigns :string_field).to be @string_field_mock
          expect(flash[:notice]).to match /String field successfully updated/i
          expect(response).to redirect_to field_set_path(@location_field_set_mock)
        end
      end

      describe 'w/o #update' do
        before do
          string_field_mk.should_receive(:update).with(valid_attributes_human) { false }
          string_field_mk.should_not_receive(:constraints_store)
          put :update, id: '21', string_field: valid_attributes.merge('some' => 'attribute')
        end
        it do
          # @string_field_mock.should_receive(:constraints_fetch)
          expect(assigns :parent_p).to be true
          expect(flash[:alert]).to match /Failed to update string field/i
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE destroy' do
      before do
        string_field_mk.should_receive(:garbage_collect_and_self_destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :string_field).to be @string_field_mock
        expect(flash[:notice]).to match /String field successfully destroyed/i
        expect(response).to redirect_to field_set_path(@location_field_set_mock)
      end
    end
  end

private

  def valid_attributes() {
    'field_set_id' => '55',
    'length_max' => '144',
    'length_min' => '3',
    'name' => 'Size',
    'row_position' => '5'}
  end

  def valid_attributes_human
    valid_attributes.merge('row_position' => '4')
  end
end
