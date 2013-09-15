require 'spec_helper'

describe EducationLevelsController do
  describe 'GET index' do
    before do
      EducationLevel.should_receive(:by_row) { ['o1','o2','o3'] }
      get :index
    end
    it do
      expect(assigns :education_levels).to eql ['o1','o2','o3']
      expect(response).to render_template :index
    end
  end

  describe 'GET new' do
    before do
      EducationLevel.should_receive(:new) { education_level_mk }
      get :new
    end
    it do
      expect(assigns :education_level).to be @education_level_mock
      expect(response).to render_template :new
    end
  end

  context 'POST create' do
    describe 'w #save' do
      before do
        EducationLevel.should_receive(:new).with(valid_attributes) { education_level_mk(save: true) }
        post :create, education_level: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :education_level).to be @education_level_mock
        expect(flash[:notice]).to match /Education level successfully created/i
        expect(response).to redirect_to education_levels_path
      end
    end

    describe 'w/o #save' do
      before do
        EducationLevel.should_receive(:new).with(valid_attributes) { education_level_mk(save: false) }
        post :create, education_level: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :new }
    end
  end

  describe 'GET edit' do
    before do
      EducationLevel.should_receive(:find).with('3') { education_level_mk }
      get :edit, id: '3'
    end
    it do
      expect(assigns :education_level).to be @education_level_mock
      expect(response).to render_template :edit
    end
  end

  context 'DELETE destroy' do
    describe 'w #destroyable?' do
      before do
        EducationLevel.should_receive(:find).with('3') { education_level_mk(destroyable?: true) }
        education_level_mk.should_receive(:destroy)
        delete :destroy, id: '3'
      end
      it do
        expect(assigns :education_level).to be @education_level_mock
        expect(flash[:notice]).to match /Education level successfully destroyed/i
        expect(response).to redirect_to education_levels_path
      end
    end

    describe 'w/o #destroyable?' do
      before do
        EducationLevel.should_receive(:find).with('3') { education_level_mk(destroyable?: false) }
        education_level_mk.should_not_receive(:destroy)
        delete :destroy, id: '3'
      end
      it { expect(response).to redirect_to root_path }
    end
  end

  context 'PUT update' do
    describe 'w #update' do
      before do
        EducationLevel.should_receive(:find).with('3') { education_level_mk }
        education_level_mk.should_receive(:update).with(valid_attributes_human) { true }
        put :update, id: '3', education_level: valid_attributes.merge('some' => 'attribute')
      end
      it do
        expect(assigns :education_level).to be @education_level_mock
        expect(flash[:notice]).to match /Education level successfully updated/i
        expect(response).to redirect_to education_levels_path
      end
    end

    describe 'w/o #update' do
      before do
        EducationLevel.should_receive(:find).with('3') { education_level_mk }
        education_level_mk.should_receive(:update).with(valid_attributes_human) { false }
        put :update, id: '3', education_level: valid_attributes.merge('some' => 'attribute')
      end
      it { expect(response).to render_template :edit }
    end
  end

private

  def valid_attributes() {
    'description' => 'Age 25 and older',
    'name' => 'High school',
    'row_position' => '2'}
  end

  def valid_attributes_human
    valid_attributes.merge('row_position' => '1')
  end
end
