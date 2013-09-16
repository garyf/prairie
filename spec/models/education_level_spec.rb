require 'spec_helper'

describe EducationLevel do
  context '#destroyable?' do
    before { @o = EducationLevel.new }
    describe 'w 1 person' do
      before { @o.stub_chain(:people, :count) { 1 } }
      it { expect(@o.destroyable?).to be false }
    end

    describe 'w 0 people' do
      before { @o.stub_chain(:people, :count) { 0 } }
      it { expect(@o.destroyable?).to be true }
    end
  end
end
