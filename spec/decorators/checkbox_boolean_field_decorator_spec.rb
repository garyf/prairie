# coding: utf-8
require 'spec_helper'

describe CheckboxBooleanFieldDecorator do
  before { bld(id: 8) }
  context '#link_to_value_edit' do
    context 'w value_str' do
      before { @o.stub_chain(:choices, :name_pluck_by_row) { ['True','False'] } }
      describe '== 1' do
        subject { @o.link_to_value_edit(34, '1') }
        it do
          expect(subject).to match /checkbox_boolean_fields\/8\/edit/
          expect(subject).to match /\?parent_id=34/
          expect(subject).to match /True/
        end
      end

      it '!= 1' do
        expect(@o.link_to_value_edit 34, '0').to match /False/
      end
    end

    it 'w/o value_str' do
      expect(@o.link_to_value_edit 34).to match /checkbox, undefined/
    end
  end

  describe '#search_input' do
    subject { @o.search_input }
    it do
      expect(subject).to match /checkbox/
      expect(subject).to match /field_8_gist/
    end
  end

private

  def bld(options = {})
    @o = CheckboxBooleanField.new(options).extend CheckboxBooleanFieldDecorator
  end
end
