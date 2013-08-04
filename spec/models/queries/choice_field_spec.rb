require 'spec_helper'

describe ChoiceField do
  context '#choice_row_edit_able?' do
    before { choice_cr }
    it 'w 1 choice' do
      expect(@o.choice_row_edit_able?).to be false
    end

    describe 'w 2 choices' do
      before { choice_cr }
      it { expect(@o.choice_row_edit_able?).to be true }
    end
  end

private

  def cr
    @o = FactoryGirl.create(:person_select_field)
  end

  def choice_cr(options = {})
    @o ||= cr
    FactoryGirl.create(:choice, {
      custom_field: @o}.merge(options))
  end
end
