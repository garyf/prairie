require 'spec_helper'

describe PersonSearch do
  context '#column_find_ids' do
    describe 'w/o a search term' do
      before { bld }
      it { expect(@o.column_find_ids({'name_last' => ''})).to be nil }
    end

    context 'w 2 people' do
      before do
        @person0 = c_person_cr(name_last: 'Anders', email: 'ndr@example.com')
        @person1 = c_person_cr(name_last: 'anders', email: 'geo@example.com')
        @person2 = c_person_cr(name_last: 'foo', email: 'foo@example.com')
        bld
      end
      context 'w 1 search term' do
        it 'w matching term' do
          expect(@o.column_find_ids({'name_last' => 'Anders'})).to match_array [@person0.id, @person1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_find_ids({'name_last' => 'bar'})).to eql []
        end
      end

      context 'w 2 search terms' do
        it 'w matching term' do
          expect(@o.column_find_ids({
            'name_last' => 'Anders',
            'email' => 'geo@example.com'})).to match_array [@person1.id]
        end
        it 'w/o matching term' do
          expect(@o.column_find_ids({
            'name_last' => 'Anders',
            'email' => 'foo@example.com'})).to eql []
        end
      end
    end
  end

  context 'super #custom_result_ids' do
    before { bld }
    context 'w 1 field_set, 1 custom_field' do
      before { @string_field0 = string_field_mk(id: 34) }
      context 'w a search term' do
        before { CustomField.should_receive(:find).with('34') { @string_field0 } }
        describe 'w matching term' do
          before { @string_field0.should_receive(:parents_find_by_gist).with('foo') { [8, 55] } }
          it { expect(@o.custom_result_ids({"field_#{@string_field0.id}_gist" => 'foo'})).to eql [8, 55] }
        end

        describe 'w/o matching term' do
          before { @string_field0.should_receive(:parents_find_by_gist).with('bar') { [] } }
          it { expect(@o.custom_result_ids({"field_#{@string_field0.id}_gist" => 'bar'})).to eql [] }
        end
      end

      describe 'w/o a search term' do
        before { CustomField.should_not_receive(:find) }
        it { expect(@o.custom_result_ids({"field_#{@string_field0.id}_gist" => ''})).to be nil }
      end
    end
  end

  context 'super #all_agree_find_ids' do
    before do
      bld
      @params = {'these' => 'params'}
    end
    describe 'w #column_find_ids empty?' do
      before { @o.should_receive(:column_find_ids).with(@params) { [] } }
      it { expect(@o.all_agree_find_ids @params).to eql [] }
    end

    context 'w/o #column_find_ids' do
      before { @o.should_receive(:column_find_ids).with(@params) { nil } }
      describe 'w #custom_result_ids empty?' do
        before { @o.should_receive(:custom_result_ids).with(@params) { [] } }
        it { expect(@o.all_agree_find_ids @params).to eql [] }
      end

      describe 'w #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(@params) { [5, 8, 3] } }
        it { expect(@o.all_agree_find_ids @params).to match_array [3, 5, 8] }
      end

      describe 'w/o #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(@params) { nil } }
        it { expect(@o.all_agree_find_ids @params).to match_array [] }
      end
    end

    context 'w #column_find_ids' do
      before { @o.should_receive(:column_find_ids).with(@params) { [8, 13, 5] } }
      describe 'w #custom_result_ids empty?' do
        before { @o.should_receive(:custom_result_ids).with(@params) { [] } }
        it { expect(@o.all_agree_find_ids @params).to eql [] }
      end

      describe 'w #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(@params) { [5, 8, 3] } }
        it { expect(@o.all_agree_find_ids @params).to match_array [5, 8] }
      end

      describe 'w/o #custom_result_ids' do
        before { @o.should_receive(:custom_result_ids).with(@params) { nil } }
        it { expect(@o.all_agree_find_ids @params).to match_array [5, 8, 13] }
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
        @o.should_receive(:all_agree_find_ids).with(@params) { [13, 55] }
        Person.should_receive(:name_last_where_id_by_name_last).with([13, 55]) { ['p13','p55'] }
      end
      it { expect(@o.people @params).to match_array ['p13','p55'] }
    end

    describe 'w/o result_ids' do
      before do
        @o.should_receive(:all_agree_find_ids).with(@params) { [] }
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
