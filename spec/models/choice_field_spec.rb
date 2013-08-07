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
end
