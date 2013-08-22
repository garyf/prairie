require 'spec_helper'

describe PersonSearch do
  context '#results_united' do
    before do
      bld
      @params = {'these' => 'params'}
    end
    context 'w some all_agree_ids' do
      before { Person.should_receive(:find).with([21, 34]) { ['l_21','l_34'] } }
      describe 'w 1 pair of any_agree_grouped_ids' do
        before do
          @o.should_receive(:all_and_any_agree_ids_for_find).with(@params) { [[21, 34], [[3, [5, 8]]]] }
          Person.should_receive(:find).with([5, 8]) { ['l_5','l_8'] }
        end
        subject { @o.results_united(@params) }
        it { expect(subject).to match_array ['l_21','l_34','l_5','l_8'] }
        it { expect(subject[0]).to eql 'l_21' }
        it { expect(subject[2]).to eql 'l_5' }
      end

      describe 'w 2 pair of any_agree_grouped_ids' do
        before do
          @o.should_receive(:all_and_any_agree_ids_for_find).with(@params) { [[21, 34], [[3, [5, 8]], [1, [55, 89]]]] }
          Person.should_receive(:find).with([5, 8]) { ['l_5','l_8'] }
          Person.should_receive(:find).with([55, 89]) { ['l_55','l_89'] }
        end
        subject { @o.results_united(@params) }
        it { expect(subject).to match_array ['l_21','l_34','l_5','l_8','l_55','l_89'] }
        it { expect(subject[0]).to eql 'l_21' }
        it { expect(subject[2]).to eql 'l_5' }
        it { expect(subject[4]).to eql 'l_55' }
      end

      describe 'w/o any any_agree_grouped_ids' do
        before { @o.should_receive(:all_and_any_agree_ids_for_find).with(@params) { [[21, 34], []] } }
        it { expect(@o.results_united(@params)).to match_array ['l_21','l_34'] }
      end
    end

    context 'w/o any all_agree_ids' do
      describe 'w 2 pair of any_agree_grouped_ids' do
        before do
          @o.should_receive(:all_and_any_agree_ids_for_find).with(@params) { [[], [[3, [5, 8]], [1, [55, 89]]]] }
          Person.should_receive(:find).with([5, 8]) { ['l_5','l_8'] }
          Person.should_receive(:find).with([55, 89]) { ['l_55','l_89'] }
        end
        subject { @o.results_united(@params) }
        it { expect(subject).to match_array ['l_5','l_8','l_55','l_89'] }
        it { expect(subject[0]).to eql 'l_5' }
        it { expect(subject[2]).to eql 'l_55' }
      end
    end
  end

  context '#people' do
    before do
      bld
      @params = {'key0' => 'value0', 'key1' => 'value1'}
    end
    describe 'w result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [13, 55] }
        Person.should_receive(:name_last_where_id_by_name_last).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.people @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:all_agree_ids_for_find).with(@params) { [] }
        Person.should_not_receive(:name_last_where_id_by_name_last)
      end
      it { expect(@o.people @params).to eql [] }
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
