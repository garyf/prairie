# coding: utf-8
require 'spec_helper'

describe SelectFieldDecorator do
  before { bld(id: 21) }
  context '#link_to_value_edit' do
    describe 'w value_str' do
      subject { @o.link_to_value_edit(55, 'Banana') }
      it do
        expect(subject).to match /select_fields\/21\/edit/
        expect(subject).to match /\?parent_id=55/
        expect(subject).to match /Banana/
      end
    end

    it 'w/o value_str' do
      expect(@o.link_to_value_edit 55).to match /select list, undefined/
    end
  end

  describe '#search_input' do
    before { @o.stub_chain(:choices, :name_pluck_by_row) { ['Apple','Banana','Cherry'] } }
    subject { @o.search_input }
    it do
      expect(subject).to match /<select id="field_21_gist"/
      expect(subject).to match /name="field_21_gist"/
      expect(subject).to match /<option value="">Please select<\/option>/
      expect(subject).to match /<option value="Apple">Apple<\/option>/
      expect(subject).to match /<option value="Banana">Banana<\/option>/
      expect(subject).to match /<option value="Cherry">Cherry<\/option>/
      expect(subject).to match /<\/option><\/select>/
    end
  end

private

  def bld(options = {})
    @o = SelectField.new(options).extend SelectFieldDecorator
  end
end
