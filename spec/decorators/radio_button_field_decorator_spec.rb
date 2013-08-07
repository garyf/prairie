# coding: utf-8
require 'spec_helper'

describe RadioButtonFieldDecorator do
  before { bld(id: 21) }
  context '#link_to_value_edit' do
    describe 'w value_str' do
      subject { @o.link_to_value_edit(89, 'Nimrod') }
      it do
        expect(subject).to match /radio_button_fields\/21\/edit/
        expect(subject).to match /\?parent_id=89/
        expect(subject).to match /Nimrod/
      end
    end

    it 'w/o value_str' do
      expect(@o.link_to_value_edit 89).to match /radio button, undefined/
    end
  end

  describe '#search_input' do
    before { @o.stub_chain(:choices, :name_pluck_by_row) { ['Apple','Banana','Cherry'] } }
    subject { @o.search_input }
    it do
      expect(subject).to match /<input id="field_21_gist_Apple" name="field_21_gist" type="radio" value="Apple" \/><label for="Apple">Apple<\/label>/
      expect(subject).to match /<input id="field_21_gist_Banana" name="field_21_gist" type="radio" value="Banana" \/><label for="Banana">Banana<\/label>/
      expect(subject).to match /<input id="field_21_gist_Cherry" name="field_21_gist" type="radio" value="Cherry" \/><label for="Cherry">Cherry<\/label>/
    end
  end

private

  def bld(options = {})
    @o = RadioButtonField.new(options).extend RadioButtonFieldDecorator
  end
end
