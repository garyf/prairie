require 'spec_helper'

describe FieldSet do
  context '::new_able?' do
    before { LocationFieldSet.stub(:count) { 13 } }
    it 'w count >= 13' do
      expect(LocationFieldSet.new_able?).to be false
    end

    describe 'w count < 13' do
      before { PersonFieldSet.should_receive(:count) { 12 } }
      it { expect(PersonFieldSet.new_able?).to be true }
    end
  end

  context '#destroyable?, #custom_field_new_able?, #custom_field_row_edit_able?' do
    before { @o = FieldSet.new }
    context 'w/o any custom fields' do
      before { @o.stub_chain(:custom_fields, :count) { 0 } }
      it { expect(@o.destroyable?).to be true }
    end

    context 'w 1 custom field' do
      before { @o.stub_chain(:custom_fields, :count) { 1 } }
      it { expect(@o.destroyable?).to be false }
      it { expect(@o.custom_field_row_edit_able?).to be false }
    end

    context 'w 2 custom fields' do
      before { @o.stub_chain(:custom_fields, :count) { 2 } }
      it { expect(@o.custom_field_row_edit_able?).to be true }
    end

    context 'w 20 custom fields' do
      before { @o.stub_chain(:custom_fields, :count) { 20 } }
      it { expect(@o.custom_field_new_able?).to be true }
    end

    context 'w 21 custom fields' do
      before { @o.stub_chain(:custom_fields, :count) { 21 } }
      it { expect(@o.custom_field_new_able?).to be false }
    end
  end

  context '#enabled?' do
    before { cr }
    it 'w/o custom_field' do
      expect(@o.enabled?).to be false
    end

    it 'w 1 !enabled custom_field' do
      string_field_cr(enabled_p: false)
      expect(@o.enabled?).to be false
    end

    it 'w 1 enabled custom_field' do
      string_field_cr
      expect(@o.enabled?).to be true
    end
  end

private

  def cr
    @o = FactoryGirl.create(:location_field_set)
  end

  def string_field_cr(options = {})
    @o ||= cr
    FactoryGirl.create(:string_field, {
      field_set: @o}.merge(options))
  end
end
