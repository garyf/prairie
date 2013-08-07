# coding: utf-8
require 'spec_helper'

describe ChoiceDecorator do
  context '#link_to_edit' do
    before do
      bld id: 8, name: 'Violet'
      @select_field = SelectField.new
    end
    describe 'w #edit_able?' do
      before { @select_field.should_receive(:edit_able?) { true } }
      subject { @o.link_to_edit @select_field }
      it do
        expect(subject).to match /choices\/8\/edit/
        expect(subject).to match /Violet/
      end
    end

    context 'w/o #edit_able?' do
      before { @select_field.should_receive(:edit_able?) { false } }
      describe 'w #name_edit_able?' do
        before { @o.should_receive(:name_edit_able?) { true } }
        subject { @o.link_to_edit @select_field }
        it do
          expect(subject).to match /choices/
          expect(subject).to match /Violet/
        end
      end

      describe 'w/o #name_edit_able?' do
        before { @o.should_receive(:name_edit_able?) { false } }
        it { expect(@o.link_to_edit @select_field).to eql 'Violet' }
      end
    end
  end

private

  def bld(options = {})
    @o = Choice.new(options).extend ChoiceDecorator
  end
end
