require 'spec_helper'

describe ChoiceField do
  context '#choice_row_edit_able?, #enable_able?' do
    before { @o = ChoiceField.new }
    describe 'w 1 choice' do
      before { @o.stub_chain(:choices, :count) { 1 } }
      it { expect(@o.choice_row_edit_able?).to be false }
      it { expect(@o.enable_able?).to be false }
    end

    describe 'w 2 choices' do
      before { @o.stub_chain(:choices, :count) { 2 } }
      it { expect(@o.choice_row_edit_able?).to be true }
      it { expect(@o.enable_able?).to be true }
    end
  end
end
