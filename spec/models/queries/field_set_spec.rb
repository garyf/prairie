require 'spec_helper'

describe FieldSet do
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
end
