require 'spec_helper'

describe SetupChoiceFieldsController do
  context 'w params[:field_set_id]' do
    context 'w #new_allow?' do
      before { FieldSet.should_receive(:find).with('34') { person_field_set_mk(id: '34', custom_field_new_able?: true) } }
      context 'GET new' do
        describe 'w kind recognized' do
          before do
            SelectField.should_receive(:new).with(type: 'SelectField', field_set_id: '34') { select_field_mk }
            get :new, field_set_id: '34', kind: 'Select'
          end
          it do
            expect(assigns :field_set).to be @person_field_set_mock
            expect(assigns :choice_field).to be @select_field_mock
            expect(response).to render_template :new
          end
        end

        it 'w/o kind recognized' do
          expect{ get :new, field_set_id: '34', kind: 'Thing' }.to raise_error(ChoiceField::SubklassNotRecognized)
        end
      end

      context 'POST create' do
        describe 'w #save' do
          before do
            SelectField.should_receive(:new).with(valid_attributes) { select_field_mk(save: true) }
            select_field_mk.should_receive(:type_human) { 'Select list field' }
            post :create, choice_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :field_set).to be @person_field_set_mock
            expect(assigns :choice_field).to be @select_field_mock
            expect(flash[:notice]).to match /Select list field successfully created/
            expect(response).to redirect_to setup_choice_field_path(@select_field_mock)
          end
        end

        describe 'w/o #save' do
          before do
            with_errors_double
            SelectField.should_receive(:new).with(valid_attributes) { select_field_mk(save: false) }
            select_field_mk.should_receive(:type_human).with(true) { 'select list field' }
            post :create, choice_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(flash[:alert]).to match /Failed to create select list field/
            expect(response).to render_template :new
          end
        end

        it 'w/o type recognized' do
          expect{ post :create, choice_field: valid_attributes.merge('type' => 'ThingField') }.to raise_error(ChoiceField::SubklassNotRecognized)
        end
      end
    end

    context 'w/o #new_allow?' do
      before { FieldSet.should_receive(:find).with('34') { person_field_set_mk(custom_field_new_able?: false) } }
      it 'GET new' do
        get :new, field_set_id: '34'
        expect(response).to redirect_to root_path
      end

      it 'POST create' do
        post :create, choice_field: valid_attributes
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'w @choice_field' do
    before { CustomField.should_receive(:find).with('21') { select_field_mk(field_set: person_field_set_mk) } }

    describe 'GET show' do
      before do
        select_field_mk.stub_chain(:choices, :ranked_page).with('2') { ['c1','c2','c3'] }
        get :show, id: '21', page: '2'
      end
      it do
        expect(assigns :field_set).to be @person_field_set_mock
        expect(assigns :choices).to eql ['c1','c2','c3']
        expect(assigns :row_offset).to eql 9
        expect(response).to render_template :show
      end
    end

    context 'w #custom_field_row_edit_able?' do
      before { person_field_set_mk.stub(:custom_field_row_edit_able?) { true } }
      describe 'GET edit' do
        before do
          select_field_mk.should_receive(:human_row)
          get :edit, id: '21'
        end
        it do
          expect(assigns :choice_field).to be @select_field_mock
          expect(assigns :field_set).to be @person_field_set_mock
          expect(assigns :row_edit_able_p).to be true
          expect(response).to render_template :edit
        end
      end

      context 'PUT update' do
        describe 'w #update' do
          before do
            select_field_mk.should_receive(:update).with(valid_attributes_human) { true }
            @select_field_mock.should_receive(:type_human) { 'Select list field' }
            put :update, id: '21', choice_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :choice_field).to be @select_field_mock
            expect(flash[:notice]).to match /Select list field successfully updated/
            expect(response).to redirect_to field_set_path(@person_field_set_mock)
          end
        end

        describe 'w/o #update' do
          before do
            select_field_mk.should_receive(:update).with(valid_attributes_human) { false }
            @select_field_mock.should_receive(:human_row)
            @select_field_mock.should_receive(:type_human).with(true) { 'select list field' }
            put :update, id: '21', choice_field: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(flash[:alert]).to match /Failed to update select list field/
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
          select_field_mk.should_receive(:update).with(valid_attributes_human) { false }
          @select_field_mock.should_not_receive(:human_row)
          put :update, id: '21', choice_field: valid_attributes
        end
        it { expect(assigns :row_edit_able_p).to be false }
      end
    end

    describe 'DELETE destroy' do
      before do
        select_field_mk.should_receive(:garbage_collect_and_self_destroy)
        @select_field_mock.should_receive(:type_human) { 'Select list field' }
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :choice_field).to be @select_field_mock
        expect(flash[:notice]).to match /Select list field successfully destroyed/
        expect(response).to redirect_to field_set_path(@person_field_set_mock)
      end
    end
  end

private

  def valid_attributes() {
    'field_set_id' => '34',
    'name' => 'Size',
    'row_position' => '8',
    'type' => 'SelectField'}
  end

  def valid_attributes_human
    valid_attributes.merge('row_position' => '7')
  end
end
