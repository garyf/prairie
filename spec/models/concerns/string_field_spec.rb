require 'spec_helper'

describe StringField do
  context '#gist_store, #gist_fetch, #parent?' do
    before do
      @person = c_person_bs
      c_person_string_field_bs
      @params_white = {
        'gist' => 'foo',
        'parent_id' => "#{@person.id}"}
    end
    describe 'w #valid?', :redis do
      before do
        @o.should_receive(:valid?) { true }
        @o.gist_store(@person, @params_white)
      end
      subject { @o.gist_fetch(@person) }
      it do
        expect(subject.gist).to eql 'foo'
        expect(subject.parent_id).to eql @person.id
        expect(subject.parents.member? @person.id).to be true
        expect(subject.parent?).to be true
      end
    end

    describe 'w/o #valid?' do
      before do
        @o.should_receive(:valid?) { false }
        @result = @o.gist_store(@person, @params_white)
      end
      subject { @o.gist_fetch(@person) }
      it do
        expect(@result).to be false
        expect(subject.gist).to be nil
        expect(subject.parent_id).to eql @person.id
        expect(subject.parents.member? @person.id).to be false
        expect(subject.parent?).to be false
      end
    end
  end

  context '#gist_store, #gist_fetch w 2 parents', :redis do
    before do
      @person0 = c_person_bs
      @person1 = c_person_bs
      c_person_string_field_bs
      @o.should_receive(:valid?).twice { true }
      @o.gist_store(@person0, {'gist' => 'foo', 'parent_id' => "#{@person0.id}"})
      @o.gist_store(@person1, {'gist' => 'bar', 'parent_id' => "#{@person1.id}"})
    end
    it { expect(@o.parents.count).to eql 2 }
    it do
      expect(@person0.gist_fetch @o.id).to eql 'foo'
      expect(@person1.gist_fetch @o.id).to eql 'bar'
    end
  end
end
