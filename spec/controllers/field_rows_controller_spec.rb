require 'spec_helper'

describe FieldRowsController do
  context 'w @field_row' do
    before do
      FieldRow.should_receive(:find).with('21') do
        field_row_mk(
          custom_field: string_field_mk,
          field_set: person_field_set_mk)
      end
    end

    describe 'GET edit' do
      before { get :edit, id: '21' }
      it do
        expect(assigns :field_row).to be @field_row_mock
        expect(assigns :custom_field).to be @string_field_mock
        expect(assigns :field_set).to be @person_field_set_mock
        expect(response).to render_template :edit
      end
    end

    context 'PUT update' do
      describe 'w #update' do
        before do
          field_row_mk.should_receive(:update).with(valid_attributes) { true }
          put :update, id: '21', field_row: valid_attributes_human
        end
        it do
          expect(assigns :field_row).to be @field_row_mock
          expect(flash[:notice]).to match /Field row successfully updated/i
          expect(response).to redirect_to field_set_path(@person_field_set_mock)
        end
      end

      describe 'w/o #update' do
        before do
          field_row_mk.should_receive(:update).with(valid_attributes) { false }
          put :update, id: '21', field_row: valid_attributes_human
        end
        it do
          expect(flash[:alert]).to match /Failed to update field row/i
          expect(response).to render_template :edit
        end
      end
    end
  end

private

  def valid_attributes() {
    'row_position' => '8'}
  end

  def valid_attributes_human() {
    'row_position' => '9'}
  end
end
