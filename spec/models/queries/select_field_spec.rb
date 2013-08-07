require 'spec_helper'

describe SelectField do
  context '#choice_new_able?' do
    before { @o = SelectField.new }
    describe 'w 54 choices' do
      before { @o.stub_chain(:choices, :count) { 54 } }
      it { expect(@o.choice_new_able?).to be true }
    end

    describe 'w 55 choices' do
      before { @o.stub_chain(:choices, :count) { 55 } }
      it { expect(@o.choice_new_able?).to be false }
    end
  end
end
