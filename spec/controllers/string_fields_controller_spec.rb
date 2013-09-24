require 'spec_helper'

describe StringFieldsController do
  context 'w @string_field' do
    before do
      person_mk(id: '34')
      StringField.should_receive(:find).with('21') do
        string_field_mk(
          field_set: person_field_set_mk,
          parent_id: '34') # virtual
      end
      string_field_mk.should_receive(:parent).with('34') { @person_mock }
    end

    describe 'GET edit' do
      before do
        string_field_mk.should_receive(:gist_fetch).with(@person_mock)
        get :edit, id: '21', parent_id: '34'
      end
      it do
        expect(assigns :string_field).to be @string_field_mock
        expect(assigns :field_set).to be @person_field_set_mock
        expect(assigns :parent).to be @person_mock
        expect(response).to render_template :edit
      end
    end

    context 'PUT update' do
      describe 'w #gist_store' do
        before do
          string_field_mk.should_receive(:gist_store).with(@person_mock, valid_attributes) { true }
          string_field_mk.should_receive(:type_human) { 'String field' }
          put :update, id: '21', string_field: valid_attributes
        end
        it do
          expect(assigns :string_field).to be @string_field_mock
          expect(flash[:notice]).to match /String field successfully updated/i
          expect(response).to redirect_to field_values_path(field_set_id: @person_field_set_mock.id, parent_id: @person_mock.id)
        end
      end

      describe 'w/o #gist_store' do
        before do
          string_field_mk.should_receive(:gist_store).with(@person_mock, valid_attributes) { false }
          string_field_mk.should_receive(:type_human).with(true) { 'string field' }
          put :update, id: '21', string_field: valid_attributes
        end
        it do
          expect(flash[:alert]).to match /Failed to update string field/i
          expect(response).to render_template :edit
        end
      end
    end
  end

private

  def valid_attributes() {
    'gist' => 'brown',
    'parent_id' => '34'}
  end
end
