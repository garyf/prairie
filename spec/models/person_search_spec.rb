require 'spec_helper'

describe PersonSearch do
  context '#column_result_ids' do
    describe 'w/o a search term' do
      before { bld }
      it { expect(@o.column_result_ids({'name_last' => ''})).to be nil }
    end

    context 'w 2 people' do
      before do
        @person0 = c_person_cr(name_last: 'Anders', email: 'ndr@example.com')
        @person1 = c_person_cr(name_last: 'Anders', email: 'geo@example.com')
        @person2 = c_person_cr(name_last: 'foo', email: 'foo@example.com')
        bld
      end
      context 'w 1 search term' do
        it 'w matching term' do
          expect(@o.column_result_ids({'name_last' => 'Anders'})).to match_array [@person0.id, @person1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_result_ids({'name_last' => 'bar'})).to eql []
        end
      end

      context 'w 2 search terms' do
        it 'w matching term' do
          expect(@o.column_result_ids({
            'name_last' => 'Anders',
            'email' => 'geo@example.com'})).to match_array [@person1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_result_ids({
            'name_last' => 'Anders',
            'email' => 'foo@example.com'})).to eql []
        end
      end
    end
  end

  context 'super #custom_result_ids' do
    before { bld }
    context 'w 1 field_set, 1 custom_field' do
      before do
        @string_field0 = string_field_mk
        @field_set0 = person_field_set_mk(custom_fields: [@string_field0])
      end
      context 'w a search term' do
        describe 'w matching term' do
          before { @string_field0.should_receive(:parents_find_by_gist).with('foo') { ['8'] } }
          it { expect(@o.custom_result_ids([@field_set0], {"field_#{@string_field0.id}_gist" => 'foo'})).to eql ['8'] }
        end
        describe 'w/o matching term' do
          before { @string_field0.should_receive(:parents_find_by_gist).with('bar') { [] } }
          it { expect(@o.custom_result_ids([@field_set0], {"field_#{@string_field0.id}_gist" => 'bar'})).to eql [] }
        end
      end

      it 'w/o a search term' do
        expect(@o.custom_result_ids([@field_set0], {"field_#{@string_field0.id}_gist" => ''})).to be nil
      end
    end
  end

  context 'super #column_and_custom_ids' do
    before do
      bld
      @field_sets = ['s1','s2']
      @params = {'these' => 'params'}
    end
    describe 'w #column_result_ids empty?' do
      before { @o.should_receive(:column_result_ids).with(@params) { [] } }
      it { expect(@o.column_and_custom_ids @field_sets, @params).to eql [] }
    end

    context 'w/o #column_result_ids' do
      before { @o.should_receive(:column_result_ids).with(@params) { nil } }
      describe 'w #custom_result_ids empty?' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { [] } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to eql [] }
      end

      describe 'w #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { [5, 8, 3] } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to match_array [3, 5, 8] }
      end

      describe 'w/o #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { nil } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to match_array [] }
      end
    end

    context 'w #column_result_ids' do
      before { @o.should_receive(:column_result_ids).with(@params) { [8, 13, 5] } }
      describe 'w #custom_result_ids empty?' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { [] } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to eql [] }
      end

      describe 'w #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { [5, 8, 3] } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to match_array [5, 8] }
      end

      describe 'w/o #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(['s1','s2'], @params) { nil } }
        it { expect(@o.column_and_custom_ids @field_sets, @params).to match_array [5, 8, 13] }
      end
    end
  end

  context '#people' do
    before do
      bld
      PersonFieldSet.should_receive(:by_name) { ['s1','s2'] }
      @params = {'key0' => 'value0', 'key1' => 'value1'}
    end
    describe 'w result_ids' do
      before do
        @o.should_receive(:column_and_custom_ids).with(['s1','s2'], @params) { [13, 55] }
        Person.should_receive(:name_last_by_ids).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.people @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:column_and_custom_ids).with(['s1','s2'], @params) { [] }
        Person.should_not_receive(:name_last_by_ids)
      end
      it { expect(@o.people @params).to match_array [] }
    end
  end

private

  def bld
    @o = PersonSearch.new
  end
end
