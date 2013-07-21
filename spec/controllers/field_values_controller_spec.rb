require 'spec_helper'

describe FieldValuesController do
  describe 'GET index' do
    before do
      FieldSet.should_receive(:find).with('13') { person_field_set_mk }
      person_field_set_mk.stub_chain(:field_rows, :ranked_page).with('2') { ['o1','o2','o3'] }
      person_field_set_mk.should_receive(:parent).with('89') { person_mk }
      person_mk.should_receive(:field_values) { ['v1','v2','v3'] }
      get :index, field_set_id: '13', page: '2', parent_id: '89'
    end
    it do
      expect(assigns :field_set).to be @person_field_set_mock
      expect(assigns :field_rows).to eql ['o1','o2','o3']
      expect(assigns :parent).to be @person_mock
      expect(assigns :field_values).to eql ['v1','v2','v3']
      expect(response).to render_template :index
    end
  end
end
