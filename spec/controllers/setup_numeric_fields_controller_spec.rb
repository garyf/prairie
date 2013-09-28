require 'spec_helper'

describe SetupNumericFieldsController do
  context 'w params[:field_set_id]' do
    context 'w #new_allow?' do
      before { FieldSet.should_receive(:find).with('21') { person_field_set_mk(custom_field_new_able?: true) } }
      describe 'GET new' do
        before do
          person_field_set_mk.should_receive(:numeric_field_new) { numeric_field_mk }
          get :new, field_set_id: '21'
        end
        it do
          expect(assigns :field_set).to be @person_field_set_mock
          expect(assigns :numeric_field).to be @numeric_field_mock
          expect(response).to render_template :new
        end
      end

      context 'POST create' do
        describe 'w #save' do
          before do
            person_field_set_mk.should_receive(:numeric_field_new).with(valid_attributes) { numeric_field_mk(save: true) }
            numeric_field_mk.should_receive(:constraints_store).with(valid_attributes)
            @numeric_field_mock.should_receive(:type_human) { 'Numeric field' }
            post :create, numeric_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :field_set).to be @person_field_set_mock
            expect(assigns :numeric_field).to be @numeric_field_mock
            expect(flash[:notice]).to match /Numeric field successfully created/i
            expect(response).to redirect_to field_set_path(@person_field_set_mock)
          end
        end

        describe 'w/o #save' do
          before do
            person_field_set_mk.should_receive(:numeric_field_new).with(valid_attributes) { numeric_field_mk(save: false) }
            numeric_field_mk.should_not_receive(:constraints_store)
            @numeric_field_mock.should_receive(:type_human).with(true) { 'numeric field' }
            post :create, numeric_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(flash[:alert]).to match /Failed to create numeric field/i
            expect(response).to render_template :new
          end
        end
      end
    end

    context 'w/o #new_allow?' do
      before { FieldSet.should_receive(:find).with('21') { person_field_set_mk(custom_field_new_able?: false) } }
      it 'GET new' do
        get :new, field_set_id: '21'
        expect(response).to redirect_to root_path
      end

      it 'POST create' do
        post :create, numeric_field: valid_attributes
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'w @numeric_field' do
    before do
      NumericField.should_receive(:find).with('21') do
        numeric_field_mk(
          field_set: person_field_set_mk,
          parent?: true)
      end
    end
    context 'w #custom_field_row_edit_able?' do
      before { person_field_set_mk.stub(:custom_field_row_edit_able?) { true } }
      describe 'GET edit' do
        before do
          numeric_field_mk.should_receive(:constraints_fetch)
          @numeric_field_mock.should_receive(:human_row)
          get :edit, id: '21'
        end
        it do
          expect(assigns :numeric_field).to be @numeric_field_mock
          expect(assigns :field_set).to be @person_field_set_mock
          expect(assigns :row_edit_able_p).to be true
          expect(assigns :parent_p).to be true
          expect(response).to render_template :edit
        end
      end

      context 'PUT update' do
        describe 'w #update' do
          before do
            numeric_field_mk.should_receive(:update).with(valid_attributes_human) { true }
            @numeric_field_mock.should_receive(:constraints_store).with(valid_attributes)
            @numeric_field_mock.should_receive(:type_human) { 'Numeric field' }
            put :update, id: '21', numeric_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :numeric_field).to be @numeric_field_mock
            expect(flash[:notice]).to match /Numeric field successfully updated/i
            expect(response).to redirect_to field_set_path(@person_field_set_mock)
          end
        end

        describe 'w/o #update' do
          before do
            numeric_field_mk.should_receive(:update).with(valid_attributes_human) { false }
            @numeric_field_mock.should_not_receive(:constraints_store)
            @numeric_field_mock.should_receive(:constraints_fetch)
            @numeric_field_mock.should_receive(:human_row)
            @numeric_field_mock.should_receive(:type_human).with(true) { 'numeric field' }
            put :update, id: '21', numeric_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :row_edit_able_p).to be true
            expect(assigns :parent_p).to be true
            expect(flash[:alert]).to match /Failed to update numeric field/i
            expect(response).to render_template :edit
          end
        end
      end
    end

    context 'w/o #custom_field_row_edit_able?' do
      before { person_field_set_mk.stub(:custom_field_row_edit_able?) { false } }
      it 'GET edit' do
        get :edit, id: '21'
        expect(assigns :row_edit_able_p).to be false
      end

      describe 'PUT update w/o #update' do
        before do
          numeric_field_mk.should_receive(:update).with(valid_attributes_human) { false }
          @numeric_field_mock.should_not_receive(:human_row)
          put :update, id: '21', numeric_field: valid_attributes
        end
        it { expect(assigns :row_edit_able_p).to be false }
      end
    end

    describe 'DELETE destroy' do
      before do
        numeric_field_mk.should_receive(:garbage_collect_and_self_destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :numeric_field).to be @numeric_field_mock
        expect(flash[:notice]).to match /Numeric field successfully destroyed/i
        expect(response).to redirect_to field_set_path(@person_field_set_mock)
      end
    end
  end

private

  def valid_attributes() {
    'field_set_id' => '21',
    'name' => 'Size',
    'only_integer_p' => '1',
    'required_p' => '0',
    'row_position' => '5',
    'value_max' => '377',
    'value_min' => '-89'}
  end

  def valid_attributes_human
    valid_attributes.merge(
      'row_position' => '4',
      'setup_p' => true)
  end
end
