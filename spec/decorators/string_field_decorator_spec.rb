# coding: utf-8
require 'spec_helper'

describe StringFieldDecorator do
  before { bld(id: 21) }
  context '#link_to_value_edit' do
    describe 'w value_str' do
      subject { @o.link_to_value_edit(55, 'Banana') }
      it do
        expect(subject).to match /string_fields\/21\/edit/
        expect(subject).to match /\?parent_id=55/
        expect(subject).to match /Banana/
      end
    end

    it 'w/o value_str' do
      expect(@o.link_to_value_edit 55).to match /string, undefined/
    end
  end

  describe '#search_input' do
    subject { @o.search_input }
    it do
      expect(subject).to match /class="input-mini"/
      expect(subject).to match /id="field_21_gist"/
      expect(subject).to match /name="field_21_gist"/
      expect(subject).to match /type="text"/
    end
  end

private

  def bld(options = {})
    @o = StringField.new(options).extend StringFieldDecorator
  end
end
