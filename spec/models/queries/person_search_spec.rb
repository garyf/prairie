require 'spec_helper'

describe PersonSearch do
  context '#column_gather_ids w/o near_p, #column_any_gather_ids' do
    before do
      @person0 = c_person_cr(name_last: 'Anders', email: 'foo@example.com')
      @person1 = c_person_cr(name_last: 'Brady', email: 'bar@example.com')
      @person2 = c_person_cr(name_last: 'Carson', email: 'foo@example.com')
      bld
    end
    describe 'w/o any columns_w_values' do
      before do
        @params = {
          'email' => '',
          'name_last' => ''}
      end
      it { expect(@o.column_gather_ids @params, false).to be nil }
      it { expect(@o.column_any_gather_ids @params).to eql [] }
    end

    context 'w 1 search term' do
      describe 'w/o any matching' do
        before do
          @params = {
            'email' => '',
            'name_last' => 'Dixon'}
        end
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end

      describe 'w 1 matching' do
        before do
          @params = {
            'email' => '',
            'name_last' => 'Anders'}
        end
        it { expect(@o.column_gather_ids @params, false).to eql [@person0.id] }
        it { expect(@o.column_any_gather_ids @params).to eql [@person0.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w 1 all_agree parent' do
        before do
          @params = {
            'email' => 'foo@example.com',
            'name_last' => 'Carson'}
        end
        it { expect(@o.column_gather_ids @params, false). to eql [@person2.id] }
        it 'note multiple appearances of @person2' do
          expect(@o.column_any_gather_ids @params).to match_array [@person0.id, @person2.id, @person2.id]
        end
      end

      describe 'w/o any all_agree parents' do
        before do
          @params = {
            'email' => 'foo@example.com',
            'name_last' => 'Brady'}
        end
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to match_array [@person0.id, @person1.id, @person2.id] }
      end

      describe 'w/o matching term' do
        before do
          @params = {
            'email' => 'baz@example.com',
            'name_last' => 'Dixon'}
        end
        it { expect(@o.column_gather_ids @params, false).to eql [] }
        it { expect(@o.column_any_gather_ids @params).to eql [] }
      end
    end
  end

  context '#column_gather_ids w near_p' do
    before do
      @person0 = c_person_cr(name_last: 'Anders', email: 'foo@example.com')
      @person1 = c_person_cr(name_last: 'Brady', email: 'bar@example.com')
      @person2 = c_person_cr(name_last: 'Carson', email: 'foo@example.com')
      bld
    end
    describe 'w/o any #columns_w_near_values' do
      before do
        @params = {
          'email' => 'fo',
          'name_last' => 'An'}
      end
      it { expect(@o.column_gather_ids @params, true).to be nil }
    end

    context 'w 1 search term' do
      describe 'w/o any matching' do
        before do
          @params = {
            'email' => '',
            'name_last' => 'Anc'}
        end
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end

      describe 'w 1 matching' do
        before do
          @params = {
            'email' => '',
            'name_last' => 'And'}
        end
        it { expect(@o.column_gather_ids @params, true).to eql [@person0.id] }
      end
    end

    context 'w 2 search terms' do
      describe 'w both substrings by 1 parent' do
        before do
          @params = {
            'email' => 'foo',
            'name_last' => 'rso'}
        end
        it { expect(@o.column_gather_ids @params, true). to eql [@person2.id] }
      end

      describe 'w both substrings by different parents' do
        before do
          @params = {
            'email' => 'bar',
            'name_last' => 'Dixon'}
        end
        it { expect(@o.column_gather_ids @params, true). to eql [] }
      end

      describe 'w/o matching term' do
        before do
          @params = {
            'email' => 'wherever',
            'name_last' => 'Dixon',}
        end
        it { expect(@o.column_gather_ids @params, true).to eql [] }
      end
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
