require 'spec_helper'

describe FieldSet do
  context '#destroyable?, #custom_field_row_edit_able?' do
    before { cr }
    it 'w/o any custom fields' do
      expect(@o.destroyable?).to be true
    end

    context 'w 1 custom field' do
      before { custom_field_cr }
      it do
        expect(@o.destroyable?).to be false
        expect(@o.custom_field_row_edit_able?).to be false
      end

      describe 'w 2 custom fields' do
        before { custom_field_cr }
        it { expect(@o.custom_field_row_edit_able?).to be true }
      end
    end
  end

private

  def cr
    @o = FactoryGirl.create(:location_field_set)
  end

  def custom_field_cr(options = {})
    @o ||= cr
    FactoryGirl.create(:numeric_field, {
      field_set: @o}.merge(options))
  end
end
