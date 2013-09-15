require 'spec_helper'

describe PeopleController do
  describe 'GET index' do
    before do
      Person.should_receive(:by_name_last).with('2') { ['o1','o2','o3'] }
      get :index, page: '2'
    end
    it do
      expect(assigns :people).to eql ['o1','o2','o3']
      expect(response).to render_template :index
    end
  end

  describe 'GET new' do
    before do
      Person.should_receive(:new) { person_mk }
      get :new
    end
    it do
      expect(assigns :person).to be @person_mock
      expect(response).to render_template :new
    end
  end

  context 'POST create' do
    describe 'w #save' do
      before do
        Person.should_receive(:new).with(valid_attributes) { person_mk(save: true) }
        post :create, person: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :person).to be @person_mock
        expect(flash[:notice]).to match /Person successfully created/i
        expect(response).to redirect_to @person_mock
      end
    end

    describe 'w/o #save' do
      before do
        with_errors_double
        Person.should_receive(:new).with(valid_attributes) { person_mk(save: false, errors: @errors) }
        post :create, person: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :new }
    end
  end

  context 'w @person' do
    before { Person.should_receive(:find).with('21') { person_mk } }

    describe 'GET show' do
      before do
        PersonFieldSet.should_receive(:enabled_by_name) { ['s1','s2'] }
        get :show, id: '21'
      end
      it do
        expect(assigns :person).to be @person_mock
        expect(assigns :field_sets).to eql ['s1','s2']
        expect(response).to render_template :show
      end
    end

    describe 'GET edit' do
      before { get :edit, id: '21' }
      it do
        expect(assigns :person).to be @person_mock
        expect(response).to render_template :edit
      end
    end

    describe 'DELETE destroy' do
      before do
        person_mk.should_receive(:garbage_collect_and_self_destroy)
        delete :destroy, id: '21'
      end
      it do
        expect(assigns :person).to be @person_mock
        expect(flash[:notice]).to match /Person successfully destroyed/i
        expect(response).to redirect_to people_path
      end
    end
  end

  context 'PUT update' do
    describe 'w #update' do
      before do
        Person.should_receive(:find).with('21') { person_mk }
        person_mk.should_receive(:update).with(valid_attributes) { true }
        put :update, id: '21', person: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :person).to be @person_mock
        expect(flash[:notice]).to match /Person successfully updated/i
        expect(response).to redirect_to @person_mock
      end
    end

    describe 'w/o #update' do
      before do
        with_errors_double
        Person.should_receive(:find).with('21') { person_mk(errors: @errors) }
        person_mk.should_receive(:update).with(valid_attributes) { false }
        put :update, id: '21', person: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :edit }
    end
  end

private

  def valid_attributes() {
    'birth_year' => '1685',
    'education_level_id' => '2',
    'email' => 'leipzig@example.com',
    'height' => '68',
    'male_p' => '1',
    'name_first' => 'Johann',
    'name_last' => 'Bach'}
  end
end
