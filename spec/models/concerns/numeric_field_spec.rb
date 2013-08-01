require 'spec_helper'

describe StringField do
  context '#gist_store, #gist_fetch, #parent?' do
    before do
      @location = c_location_bs
      c_location_numeric_field_bs
      @params_white = {
        'gist' => '34',
        'parent_id' => "#{@location.id}"}
    end
    describe 'w #valid?', :redis do
      before do
        @o.should_receive(:valid?) { true }
        @o.gist_store(@location, @params_white)
      end
      subject { @o.gist_fetch(@location) }
      it do
        expect(subject.gist).to eql '34'
        expect(subject.parent_id).to eql @location.id
        expect(subject.parents.member? @location.id).to be true
        expect(subject.parent?).to be true
      end
    end

    describe 'w/o #valid?' do
      before do
        @o.should_receive(:valid?) { false }
        @result = @o.gist_store(@location, @params_white)
      end
      subject { @o.gist_fetch(@location) }
      it do
        expect(@result).to be false
        expect(subject.gist).to be nil
        expect(subject.parent_id).to eql @location.id
        expect(subject.parents.member? @location.id).to be false
        expect(subject.parent?).to be false
      end
    end
  end

  context '#gist_store, #gist_fetch w 2 parents', :redis do
    before do
      @location0 = c_location_bs
      @location1 = c_location_bs
      c_location_numeric_field_bs
      @o.should_receive(:valid?).twice { true }
      @o.gist_store(@location0, {'gist' => '34', 'parent_id' => "#{@location0.id}"})
      @o.gist_store(@location1, {'gist' => '89', 'parent_id' => "#{@location1.id}"})
    end
    it { expect(@o.parents.count).to eql 2 }
    it do
      expect(@location0.gist_fetch @o.id).to eql '34'
      expect(@location1.gist_fetch @o.id).to eql '89'
    end

    describe '#garbage_collect_and_self_destroy' do
      before do
        @o.should_receive(:destroy)
        @o.garbage_collect_and_self_destroy
      end
      it '#parents_gists_clear' do
        expect(@location0.gist_fetch @o.id).to be nil
        expect(@location1.gist_fetch @o.id).to be nil
      end
      it { expect(@o.parents.empty?).to be true }
      it { expect(@o.constraints.empty?).to be true }
    end
  end
end
