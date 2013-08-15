require 'spec_helper'

describe ChoicesController do
  context 'w params[:custom_field_id]' do
    context 'w #new_allow?' do
      before do
        CustomField.should_receive(:find).with('89') do
          select_field_mk(
            choice_new_able?: true,
            field_set: person_field_set_mk)
        end
      end

      describe 'GET new' do
        before do
          select_field_mk.stub_chain(:choices, :new) { choice_mk }
          get :new, custom_field_id: '89'
        end
        it do
          expect(assigns :choice_field).to be @select_field_mock
          expect(assigns :choice).to be @choice_mock
          expect(assigns :field_set).to be @person_field_set_mock
          expect(assigns :name_edit_able_p).to be true
          expect(response).to render_template :new
        end
      end

      context 'POST create' do
        describe 'w #save' do
          before do
            select_field_mk.stub_chain(:choices, :new).with(valid_attributes) { choice_mk(save: true) }
            post :create, choice: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :choice_field).to be @select_field_mock
            expect(assigns :choice).to be @choice_mock
            expect(flash[:notice]).to match /Choice successfully created/i
            expect(response).to redirect_to setup_choice_field_path(@select_field_mock)
          end
        end

        describe 'w/o #save' do
          before do
            select_field_mk.stub_chain(:choices, :new).with(valid_attributes) { choice_mk(save: false) }
            post :create, choice: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :field_set).to be @person_field_set_mock
            expect(assigns :name_edit_able_p).to be true
            expect(flash[:alert]).to match /Failed to create choice/i
            expect(response).to render_template :new
          end
        end
      end
    end

    context 'w/o #new_allow?' do
      before { CustomField.should_receive(:find).with('89') { select_field_mk(choice_new_able?: false) } }
      it 'GET new' do
        get :new, custom_field_id: '89'
        expect(response).to redirect_to root_path
      end

      it 'POST create' do
        post :create, choice: valid_attributes
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'w @choice w choice_field#edit_able?' do
    before do
      Choice.should_receive(:find).with('21') do
        choice_mk(
          custom_field: select_field_mk(
            edit_able?: true,
            field_set: person_field_set_mk),
          name_edit_able?: true)
      end
    end
    context 'w #choice_row_edit_able?' do
      before { select_field_mk.stub(:choice_row_edit_able?) { true } }
      describe 'GET edit' do
        before do
          choice_mk.should_receive(:human_row)
          get :edit, id: '21'
        end
        it do
          expect(assigns :choice).to be @choice_mock
          expect(assigns :choice_field).to be @select_field_mock
          expect(assigns :field_set).to be @person_field_set_mock
          expect(assigns :row_edit_able_p).to be true
          expect(assigns :name_edit_able_p).to be true
          expect(response).to render_template :edit
        end
      end

      context 'PUT update' do
        describe 'w #update' do
          before do
            choice_mk.should_receive(:update).with(valid_attributes_human) { true }
            put :update, id: '21', choice: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :choice).to be @choice_mock
            expect(flash[:notice]).to match /Choice successfully updated/i
            expect(response).to redirect_to setup_choice_field_path(@select_field_mock)
          end
        end

        describe 'w/o #update' do
          before do
            choice_mk.should_receive(:update).with(valid_attributes_human) { false }
            @choice_mock.should_receive(:human_row)
            put :update, id: '21', choice: valid_attributes.merge('some' => 'attribute')
          end
          it do
            expect(assigns :field_set).to be @person_field_set_mock
            expect(assigns :row_edit_able_p).to be true
            expect(assigns :name_edit_able_p).to be true
            expect(flash[:alert]).to match /Failed to update choice/i
            expect(response).to render_template :edit
          end
        end
      end
    end

    context 'w/o #choice_row_edit_able?' do
      before { select_field_mk.stub(:choice_row_edit_able?) { false } }
      it 'GET edit' do
        get :edit, id: '21'
        expect(assigns :row_edit_able_p).to be false
      end

      describe 'PUT update w/o #update' do
        before do
          choice_mk.should_receive(:update).with(valid_attributes_human) { false }
          @choice_mock.should_not_receive(:human_row)
          put :update, id: '21', choice: valid_attributes
        end
        it { expect(assigns :row_edit_able_p).to be false }
      end
    end
  end

  context 'w @choice w/o choice_field#edit_able?' do
    context 'w #name_edit_able?' do
      before do
        Choice.should_receive(:find).with('21') do
          choice_mk(
            custom_field: select_field_mk(edit_able?: false),
            name_edit_able?: true)
        end
      end
      it 'GET edit' do
        get :edit, id: '21'
        expect(response).to render_template :edit
      end

      describe 'PUT update' do
        before do
          choice_mk.should_receive(:update).with(valid_attributes_human) { true }
          put :update, id: '21', choice: valid_attributes
        end
        it { expect(response).to redirect_to setup_choice_field_path(@select_field_mock) }
      end
    end

    describe 'w/o #name_edit_able?' do
      before do
        Choice.should_receive(:find).with('21') do
          choice_mk(
            custom_field: select_field_mk(edit_able?: false),
            name_edit_able?: false)
        end
      end
      it 'GET edit' do
        get :edit, id: '21'
        expect(response).to redirect_to root_path
      end

      it 'PUT update' do
        put :update, id: '21', choice: valid_attributes
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'DELETE destroy' do
    describe 'w #destroyable?' do
      before do
        Choice.should_receive(:find).with('21') do
          choice_mk(
            custom_field: select_field_mk,
            destroyable?: true)
        end
        choice_mk.should_receive(:choice_field_enablement_confirm_and_self_destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :choice).to be @choice_mock
        expect(assigns :choice_field).to be @select_field_mock
        expect(flash[:notice]).to match /Choice successfully destroyed/i
        expect(response).to redirect_to setup_choice_field_path(@select_field_mock)
      end
    end

    describe 'w/o #destroyable?' do
      before do
        Choice.should_receive(:find).with('21') do
          choice_mk(
            custom_field: select_field_mk,
            destroyable?: false)
        end
        choice_mk.should_not_receive(:destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :choice_field).to be @select_field_mock
        expect(response).to redirect_to root_path
      end
    end
  end

private

  def valid_attributes() {
    'custom_field_id' => '89',
    'name' => 'Seal brown',
    'row_position' => '5'}
  end

  def valid_attributes_human
    valid_attributes.merge('row_position' => '4')
  end
end
