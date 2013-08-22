require 'spec_helper'

describe Search do
  context '#custom_all_gather_ids, #custom_any_gather_ids' do
    before { bld }
    context 'w 3 custom fields' do
      before do
        @numeric_field = numeric_field_mk(id: 55)
        @select_field = select_field_mk(id: 34)
        @string_field = string_field_mk(id: 21)
      end
      describe 'w/o any params_custom_w_values' do
        before do
          @params = {
            "field_#{@numeric_field.id}_gist" => '',
            "field_#{@select_field.id}_gist" => '',
            "field_#{@string_field.id}_gist" => ''}
        end
        it { expect(@o.custom_all_gather_ids @params).to be nil }
        it { expect(@o.custom_any_gather_ids @params).to eql [] }
      end

      context 'w 1 search term' do
        before do
          CustomField.should_receive(:find).with('55') { @numeric_field }
          @params = {
            "field_#{@numeric_field.id}_gist" => '89',
            "field_#{@select_field.id}_gist" => '',
            "field_#{@string_field.id}_gist" => ''}
        end
        describe 'w/o any matching' do
          before { @numeric_field.should_receive(:parents_find_by_gist).with('89') { [] } }
          it { expect(@o.custom_all_gather_ids @params).to eql [] }
          it { expect(@o.custom_any_gather_ids @params).to eql [] }
        end

        describe 'w 1 matching' do
          before { @numeric_field.should_receive(:parents_find_by_gist).with('89') { [1, 2] } }
          it { expect(@o.custom_all_gather_ids @params).to eql [1, 2] }
          it { expect(@o.custom_any_gather_ids @params).to eql [1, 2] }
        end
      end

      context 'w 2 search terms' do
        before do
          CustomField.should_receive(:find).with('34') { @select_field }
          CustomField.should_receive(:find).with('21') { @string_field }
          @params = {
            "field_#{@numeric_field.id}_gist" => '',
            "field_#{@select_field.id}_gist" => '8',
            "field_#{@string_field.id}_gist" => 'foo'}
        end
        describe 'w 1 all_agree parent' do
          before do
            @select_field.should_receive(:parents_find_by_gist).with('8') { [3, 4] }
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [4, 5] }
          end
          it { expect(@o.custom_all_gather_ids @params).to eql [4] }
          it { expect(@o.custom_any_gather_ids @params).to eql [3, 4, 4, 5] }
        end

        describe 'w/o any all_agree parents' do
          before do
            @select_field.should_receive(:parents_find_by_gist).with('8') { [3, 4] }
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [5, 6] }
          end
          it { expect(@o.custom_all_gather_ids @params).to eql [] }
          it { expect(@o.custom_any_gather_ids @params).to eql [3, 4, 5, 6] }
        end
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
    describe 'w #all_agree_ids_few?' do
      before do
        @all_agree_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN - 1 }
        @any_agree_ids = double('array of any_agree_ids')
        @o.should_receive(:any_agree_ids_for_find).with(@params, @all_agree_ids) { @any_agree_ids }
      end
      it { expect(@o.all_and_any_agree_ids_for_find @params).to eql [@all_agree_ids, @any_agree_ids] }
    end

    describe 'w/o #all_agree_ids_few?' do
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