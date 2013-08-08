require 'spec_helper'

describe CheckboxBooleanFieldsController do
  context 'w @checkbox_boolean_field' do
    before do
      location_mk(id: '34')
      ChoiceField.should_receive(:find).with('21') do
        checkbox_boolean_field_mk(
          field_set: location_field_set_mk,
          parent_id: '34') # virtual
      end
      checkbox_boolean_field_mk.should_receive(:parent).with('34') { @location_mock }
      @checkbox_boolean_field_mock.should_not_receive(:choices) # unnecessary in subKlass
    end

    describe 'GET edit' do
      before do
        checkbox_boolean_field_mk.should_receive(:gist_fetch).with(@location_mock)
        get :edit, id: '21', parent_id: '34'
      end
      it do
        expect(assigns :choice_field).to be @checkbox_boolean_field_mock
        expect(assigns :field_set).to be @location_field_set_mock
        expect(assigns :parent).to be @location_mock
        expect(response).to render_template :edit
      end
    end

    context 'PUT update' do
      describe 'w #gist_store' do
        before do
          checkbox_boolean_field_mk.should_receive(:gist_store).with(@location_mock, valid_attributes) { true }
          @checkbox_boolean_field_mock.should_receive(:type_human) { 'Checkbox field' }
          put :update, id: '21', choice_field: valid_attributes
        end
        it do
          expect(assigns :choice_field).to be @checkbox_boolean_field_mock
          expect(flash[:notice]).to match /Checkbox field successfully updated/i
          expect(response).to redirect_to field_values_path(field_set_id: @location_field_set_mock.id, parent_id: @location_mock.id)
        end
      end

      describe 'w/o #gist_store' do
        before do
          checkbox_boolean_field_mk.should_receive(:gist_store).with(@location_mock, valid_attributes) { false }
          @checkbox_boolean_field_mock.should_not_receive(:choices)
          @checkbox_boolean_field_mock.should_receive(:type_human).with(true) { 'checkbox field' }
          put :update, id: '21', choice_field: valid_attributes
        end
        it do
          expect(assigns :field_set).to be @location_field_set_mock
          expect(assigns :parent).to be @location_mock
          expect(flash[:alert]).to match /Failed to update checkbox field/i
          expect(response).to render_template :edit
        end
      end
    end
  end

private

  def valid_attributes() {
    'gist' => '1',
    'parent_id' => '34'}
  end
end
