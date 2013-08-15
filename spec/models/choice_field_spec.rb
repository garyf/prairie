require 'spec_helper'

describe ChoiceField do
  context '#edit_able?' do
    before { @o = ChoiceField.new }
    describe 'w/o parent?' do
      before { @o.should_receive(:parent?) { false } }
      it { expect(@o.edit_able?).to be true }
    end

    context 'w parent?' do
      before { @o.should_receive(:parent?) { true } }
      describe 'w #choice_row_edit_able?' do
        before { @o.should_receive(:choice_row_edit_able?) { true } }
        it { expect(@o.edit_able?).to be true }
      end

      describe 'w #choice_row_edit_able?' do
        before { @o.should_receive(:choice_row_edit_able?) { false } }
        it { expect(@o.edit_able?).to be false }
      end
    end
  end

  context '#enablement_confirm' do
    context 'w :enabled_p' do
      before { @o = ChoiceField.new }
      describe 'w 3 choices' do
        before do
          @o.stub_chain(:choices, :count) { 3 }
          @o.enablement_confirm
        end
        it { expect(@o.enabled_p).to be true }
      end

      describe 'w 2 choices' do
        before do
          @o.stub_chain(:choices, :count) { 2 }
          @o.enablement_confirm
        end
        it { expect(@o.enabled_p).to be false }
      end
    end
  end
end
