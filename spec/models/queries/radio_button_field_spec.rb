require 'spec_helper'

describe RadioButtonField do
  context '#choice_new_able?' do
    before { @o = RadioButtonField.new }
    describe 'w 1 choice' do
      before { @o.stub_chain(:choices, :count) { 7 } }
      it { expect(@o.choice_new_able?).to be true }
    end

    describe 'w 2 choices' do
      before { @o.stub_chain(:choices, :count) { 8 } }
      it { expect(@o.choice_new_able?).to be false }
    end
  end
end
