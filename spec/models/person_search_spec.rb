require 'spec_helper'

describe PersonSearch do
  context '#column_all_gather_ids' do
    describe 'w/o a search term' do
      before { bld }
      it { expect(@o.column_all_gather_ids({'name_last' => ''})).to be nil }
    end

    context 'w 3 people' do
      before do
        @person0 = c_person_cr(name_last: 'Anders', email: 'foo@example.com')
        @person1 = c_person_cr(name_last: 'Brady', email: 'bar@example.com')
        @person2 = c_person_cr(name_last: 'Carson', email: 'baz@example.com')
        bld
      end
      context 'w 1 search term' do
        it 'w matching term' do
          expect(@o.column_all_gather_ids({'name_last' => 'Anders'})).to match_array [@person0.id]
        end
        it 'w/o matching term' do
          expect(@o.column_all_gather_ids({'name_last' => 'bar'})).to eql []
        end
      end

      context 'w 2 search terms' do
        describe 'w 2 matching terms' do
          before do
            @params = {
              'name_last' => 'Anders',
              'email' => 'bar@example.com'}
          end
          it { expect(@o.column_all_gather_ids @params).to eql [] }
        end

        describe 'w 1 matching term' do
          before do
            @params = {
              'name_last' => 'Brady',
              'email' => 'wherever@example.com'}
          end
          it { expect(@o.column_all_gather_ids @params).to match_array [] }
        end

        describe 'w/o matching term' do
          before do
            @params = {
              'name_last' => 'Name',
              'email' => 'wherever@example.com'}
          end
          it { expect(@o.column_all_gather_ids @params).to eql [] }
        end
      end
    end
  end

  context 'super #custom_all_gather_ids' do
    before { bld }
    context 'w 1 string field' do
      before { @string_field = string_field_mk(id: 34) }
      context 'w a search term' do
        before { CustomField.should_receive(:find).with('34') { @string_field } }
        describe 'w matching term' do
          before do
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [8, 55] }
            @params = {"field_#{@string_field.id}_gist" => 'foo'}
          end
          it { expect(@o.custom_all_gather_ids @params).to eql [8, 55] }
        end

        describe 'w/o matching term' do
          before do
            @string_field.should_receive(:parents_find_by_gist).with('bar') { [] }
            @params = {"field_#{@string_field.id}_gist" => 'bar'}
          end
          it { expect(@o.custom_all_gather_ids @params).to eql [] }
        end

        context 'w 1 numeric field w 2 search terms' do
          before do
            @numeric_field = numeric_field_mk(id: 55)
            CustomField.stub(:find).with('55') { @numeric_field }
            @params = {
              "field_#{@string_field.id}_gist" => 'foo',
              "field_#{@numeric_field.id}_gist" => 'bar'}
          end
          describe 'w 2 matching terms' do
            before do
              @string_field.should_receive(:parents_find_by_gist).with('foo') { [8, 55] }
              @numeric_field.should_receive(:parents_find_by_gist).with('bar') { [8, 21] }
            end
            it { expect(@o.custom_all_gather_ids @params).to eql [8] }
          end

          describe 'w 1 matching term' do
            before do
              @string_field.should_receive(:parents_find_by_gist).with('foo') { [] }
              @numeric_field.stub(:parents_find_by_gist).with('bar') { [8, 21] }
            end
            it { expect(@o.custom_all_gather_ids @params).to eql [] }
          end
        end
      end

      describe 'w/o a search term' do
        before { CustomField.should_not_receive(:find) }
        it { expect(@o.custom_all_gather_ids({"field_#{@string_field.id}_gist" => ''})).to be nil }
      end
    end
  end

  context 'super #all_agree_ids_for_find' do
    before do
      bld
      @params = {'these' => 'params'}
    end
    describe 'w #column_all_gather_ids empty?' do
      before { @o.should_receive(:column_all_gather_ids).with(@params) { [] } }
      it { expect(@o.all_agree_ids_for_find @params).to eql [] }
    end

    context 'w/o #column_all_gather_ids' do
      before { @o.should_receive(:column_all_gather_ids).with(@params) { nil } }
      describe 'w #custom_all_gather_ids empty?' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { [] } }
        it { expect(@o.all_agree_ids_for_find @params).to eql [] }
      end

      describe 'w #custom_all_gather_ids' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { [5, 8, 3] } }
        it { expect(@o.all_agree_ids_for_find @params).to match_array [3, 5, 8] }
      end

      describe 'w/o #custom_all_gather_ids' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { nil } }
        it { expect(@o.all_agree_ids_for_find @params).to match_array [] }
      end
    end

    context 'w #column_all_gather_ids' do
      before { @o.should_receive(:column_all_gather_ids).with(@params) { [8, 13, 5] } }
      describe 'w #custom_all_gather_ids empty?' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { [] } }
        it { expect(@o.all_agree_ids_for_find @params).to eql [] }
      end

      describe 'w #custom_all_gather_ids' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { [5, 8, 3] } }
        it { expect(@o.all_agree_ids_for_find @params).to match_array [5, 8] }
      end

      describe 'w/o #custom_all_gather_ids' do
        before { @o.should_receive(:custom_all_gather_ids).with(@params) { nil } }
        it { expect(@o.all_agree_ids_for_find @params).to match_array [5, 8, 13] }
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
