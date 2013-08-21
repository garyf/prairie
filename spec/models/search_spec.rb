require 'spec_helper'

describe Search do
  context '#custom_all_gather_ids' do
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

  context '#all_agree_ids_for_find' do
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

  context '#custom_parent_appearances' do
    before { bld }
    context 'w 1 string field' do
      before do
        @string_field = string_field_mk(id: 34)
        CustomField.should_receive(:find).with('34') { @string_field }
      end
      describe 'w matching term' do
        before { @string_field.should_receive(:parents_find_by_gist).with('foo') { [8, 55] } }
        it { expect(@o.custom_parent_appearances({"field_#{@string_field.id}_gist" => 'foo'})).to eql [8, 55] }
      end

      describe 'w/o matching term' do
        before { @string_field.should_receive(:parents_find_by_gist).with('bar') { [] } }
        it { expect(@o.custom_parent_appearances({"field_#{@string_field.id}_gist" => 'bar'})).to eql [] }
      end

      context 'w 1 numeric field w 2 search terms' do
        before do
          @numeric_field = numeric_field_mk(id: 55)
          CustomField.stub(:find).with('55') { @numeric_field }
          @hsh = {
            "field_#{@string_field.id}_gist" => 'foo',
            "field_#{@numeric_field.id}_gist" => 'bar'}
        end
        describe 'w 2 matching terms' do
          before do
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [8, 55] }
            @numeric_field.should_receive(:parents_find_by_gist).with('bar') { [8, 21] }
          end
          it { expect(@o.custom_parent_appearances(@hsh)).to eql [8, 55, 8, 21] }
        end

        describe 'w 1 matching term' do
          before do
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [] }
            @numeric_field.stub(:parents_find_by_gist).with('bar') { [8, 21] }
          end
          it { expect(@o.custom_parent_appearances(@hsh)).to eql [8, 21] }
        end
      end
    end
  end

  context 'w 4 parents appearing' do
    before do
      bld
      @parent_ids = [6, 6, 1, 1, 4, 3, 5, 5, 5, 5, 5, 2, 2, 2]
    end
    describe '#parent_distribution' do
      subject { @o.parent_distribution @parent_ids }
      it do
        expect(subject).to include 1 => 2
        expect(subject).to include 2 => 3
        expect(subject).to include 3 => 1
        expect(subject).to include 4 => 1
        expect(subject).to include 5 => 5
      end
    end

    describe '#parent_ids_by_agree_frequency' do
      subject { @o.parent_ids_by_agree_frequency @parent_ids }
      it do
        expect(subject).to match_array [[5, [5]], [3, [2]], [2, [6, 1]], [1, [4, 3]]]
        expect(subject[0][0]).to eql 5
        expect(subject[1][0]).to eql 3
        expect(subject[2][0]).to eql 2
        expect(subject[3][0]).to eql 1
      end
    end
  end

  context '#any_agree_ids_for_find' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_agree_ids = [13, 21]
    end
    context 'w #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [5, 8, 3, 21] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_agree_ids).to match_array [[2, [5, 8]], [1, [3, 34]]] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_agree_ids).to match_array [[1, [5, 8, 3]]] }
      end
    end

    context 'w/o #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34, 8, 8] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_agree_ids).to match_array [[3, [8]], [1, [5, 34]]] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_agree_ids).to eql [] }
      end
    end
  end

  context '#all_and_any_agree_ids_for_find' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_agree_ids = double('array of all_agree_ids')
      @o.should_receive(:all_agree_ids_for_find).with(@params) { @all_agree_ids }
    end
    describe 'w #any_agree_ids_few?' do
      before do
        @all_agree_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN - 1 }
        @any_agree_ids = double('array of any_agree_ids')
        @o.should_receive(:any_agree_ids_for_find).with(@params, @all_agree_ids) { @any_agree_ids }
      end
      it { expect(@o.all_and_any_agree_ids_for_find @params).to eql [@all_agree_ids, @any_agree_ids] }
    end

    describe 'w/o #any_agree_ids_few?' do
      before do
        @all_agree_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN }
        @o.should_not_receive(:any_agree_ids_for_find)
      end
      it { expect(@o.all_and_any_agree_ids_for_find @params).to eql [@all_agree_ids, []] }
    end
  end

private

  def bld
    @o = Search.new
  end
end