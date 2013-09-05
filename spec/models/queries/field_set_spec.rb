require 'spec_helper'

describe FieldSet do
  context 'w 3 field sets' do
    before do
      @o0 = cr(name: 'Alpha')
      @o1 = cr(name: 'Gamma')
      @o2 = cr(name: 'Beta')
    end
    describe '::by_name' do
      subject { FieldSet.by_name }
      it do
        expect(subject[0]).to eql @o0
        expect(subject[1]).to eql @o2
        expect(subject[2]).to eql @o1
      end
    end

    describe '::enabled_by_name' do
      before do
        string_field_cr(field_set: @o0)
        string_field_cr(field_set: @o1, enabled_p: false)
        string_field_cr(field_set: @o2)
      end
      subject { FieldSet.enabled_by_name }
      it do
        expect(subject).to match_array [@o0, @o2]
        expect(subject[0]).to eql @o0
        expect(subject[1]).to eql @o2
        expect(subject.count).to eql 2
      end
    end
  end

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

private

  def cr(options = {})
    FactoryGirl.create(:location_field_set, options)
  end

  def cr1
    @o = FactoryGirl.create(:location_field_set)
  end

  def string_field_cr(options = {})
    @o ||= cr1
    FactoryGirl.create(:string_field, {
      field_set: @o}.merge(options))
  end
end
