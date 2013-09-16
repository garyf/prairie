require 'spec_helper'

describe PersonSearch do
  context '#column_gather_ids w/o near_p, #column_any_gather_ids' do
    before do
      @person0 = c_person_cr(name_last: 'Anders', email: 'foo@example.com', height: 68, male_p: false)
      @person1 = c_person_cr(name_last: 'Brady', email: 'bar@example.com', height: 70, male_p: true)
      @person2 = c_person_cr(name_last: 'Carson', email: 'foo@example.com', height: 72, male_p: false)
      bld
      @params_blank = {
        'email' => '',
        'name_last' => '',
        'height' => ''}
    end
    describe 'w/o any columns_w_values' do
      it { expect(@o.column_gather_ids @params_blank, false).to be nil }
      it { expect(@o.column_any_gather_ids @params_blank).to eql [] }
    end

    context 'w 1 string term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('name_last' => 'Dixon') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('name_last' => 'Anders') }
        it { expect(@o.column_gather_ids @params, false).to eql [@person0.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@person0.id] }
      end
    end

    context 'w 1 numeric term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('height' => '74') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('height' => '70') }
        it { expect(@o.column_gather_ids @params, false).to eql [@person1.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@person1.id] }
      end
    end

    context 'w 1 boolean term' do
      describe 'w 1 matching' do
        before { @params = @params_blank.merge('male_p' => '1') }
        it { expect(@o.column_gather_ids @params, false).to eql [@person1.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@person1.id] }
      end

      describe 'w 2 matching' do
        before { @params = @params_blank.merge('male_p' => '0') }
        it { expect(@o.column_gather_ids @params, false).to eql [@person0.id, @person2.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@person0.id, @person2.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w 1 all_agree parent' do
        before { @params = @params_blank.merge('email' => 'foo@example.com', 'height' => '72') }
        it { expect(@o.column_gather_ids @params, false). to eql [@person2.id] }
        it 'note multiple appearances of @person2' do
          expect(@o.column_any_gather_ids @params).to match_array [@person0.id, @person2.id, @person2.id]
        end
      end

      describe 'w/o any all_agree parents' do
        before { @params = @params_blank.merge('email' => 'foo@example.com', 'name_last' => 'Brady') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to match_array [@person0.id, @person1.id, @person2.id] }
      end

      describe 'w/o matching term' do
        before { @params = @params_blank.merge('email' => 'baz@example.com', 'name_last' => 'Dixon') }
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end
    end
  end

  context '#column_gather_ids w near_p' do
    before do
      @person0 = c_person_cr(name_last: 'Anders', email: 'foo@example.com', height: 20)
      @person1 = c_person_cr(name_last: 'Brady', email: 'bar@example.com', height: 30)
      @person2 = c_person_cr(name_last: 'Carson', email: 'foo@example.com', height: 40)
      bld
      @params_blank = {
        'email' => '',
        'name_last' => '',
        'height' => ''}
    end

    it 'w/o any #columns_w_near_values' do
      expect(@o.column_gather_ids @params_blank, true).to be nil
    end

    context 'w 1 string term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('name_last' => 'Anc') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('name_last' => 'And') }
        it { expect(@o.column_gather_ids @params, true).to eql [@person0.id] }
      end
    end

    context 'w 1 numeric term' do
      describe 'w/o any matching' do
        before { @params = @params_blank.merge('height' => '50') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end

      describe 'w 1 matching' do
        before { @params = @params_blank.merge('height' => '19') }
        it { expect(@o.column_gather_ids @params, true).to eql [@person0.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w both substrings by 1 parent' do
        before { @params = @params_blank.merge('email' => 'foo', 'height' => '42') }
        it { expect(@o.column_gather_ids @params, true). to eql [@person2.id] }
      end

      describe 'w both substrings by different parents' do
        before { @params = @params_blank.merge('email' => 'bar', 'height' => '19') }
        it { expect(@o.column_gather_ids @params, true). to eql [] }
      end

      describe 'w/o matching term' do
        before { @params = @params_blank.merge('email' => 'wherever', 'height' => '50') }
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
