require 'spec_helper'

describe Search do
  context '#custom_gather_ids w/o near_p, #custom_any_gather_ids' do
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
            "field_#{@string_field.id}_substring_gist" => ''}
        end
        it { expect(@o.custom_gather_ids @params, false).to be nil }
        it { expect(@o.custom_any_gather_ids @params).to eql [] }
      end

      context 'w 1 search term' do
        before do
          CustomField.should_receive(:find).with('55') { @numeric_field }
          @params = {
            "field_#{@numeric_field.id}_gist" => '89',
            "field_#{@select_field.id}_gist" => '',
            "field_#{@string_field.id}_substring_gist" => ''}
        end
        describe 'w/o any matching' do
          before { @numeric_field.should_receive(:parents_find_by_gist).with('89') { [] } }
          it { expect(@o.custom_gather_ids @params, false).to eql [] }
          it { expect(@o.custom_any_gather_ids @params).to eql [] }
        end

        describe 'w 1 matching' do
          before { @numeric_field.should_receive(:parents_find_by_gist).with('89') { [1, 2] } }
          it { expect(@o.custom_gather_ids @params, false).to eql [1, 2] }
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
            "field_#{@string_field.id}_substring_gist" => 'foo'}
        end
        describe 'w 1 all_agree parent' do
          before do
            @select_field.should_receive(:parents_find_by_gist).with('8') { [3, 4] }
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [4, 5] }
          end
          it { expect(@o.custom_gather_ids @params, false).to eql [4] }
          it { expect(@o.custom_any_gather_ids @params).to eql [3, 4, 4, 5] }
        end

        describe 'w/o any all_agree parents' do
          before do
            @select_field.should_receive(:parents_find_by_gist).with('8') { [3, 4] }
            @string_field.should_receive(:parents_find_by_gist).with('foo') { [5, 6] }
          end
          it { expect(@o.custom_gather_ids @params, false).to eql [] }
          it { expect(@o.custom_any_gather_ids @params).to eql [3, 4, 5, 6] }
        end
      end
    end
  end

  context '#custom_gather_ids w near_p' do
    before { bld }
    context 'w 3 custom fields' do
      before do
        @string_field0 = mock_model(StringField)
        @string_field1 = mock_model(StringField)
        @string_field2 = mock_model(StringField)
      end
      describe 'w/o any params_custom_w_substring_values' do
        before do
          @params = {
            "field_#{@string_field0.id}_substring_gist" => 'ab',
            "field_#{@string_field1.id}_substring_gist" => 'cd',
            "field_#{@string_field2.id}_substring_gist" => 'ef'}
        end
        it { expect(@o.custom_gather_ids @params, true).to be nil }
      end

      context 'w 1 search term' do
        before do
          CustomField.should_receive(:find).with("#{@string_field0.id}") { @string_field0 }
          @params = {
            "field_#{@string_field0.id}_substring_gist" => 'foo',
            "field_#{@string_field1.id}_substring_gist" => '',
            "field_#{@string_field2.id}_substring_gist" => ''}
        end
        describe 'w/o any matching' do
          before { @string_field0.should_receive(:parents_find_by_substring).with('foo') { [] } }
          it { expect(@o.custom_gather_ids @params, true).to eql [] }
        end

        describe 'w 1 matching' do
          before { @string_field0.should_receive(:parents_find_by_substring).with('foo') { [3, 5] } }
          it { expect(@o.custom_gather_ids @params, true).to eql [3, 5] }
        end
      end

      context 'w 2 search terms' do
        before do
          CustomField.should_receive(:find).with("#{@string_field1.id}") { @string_field1 }
          @params = {
            "field_#{@string_field0.id}_substring_gist" => '',
            "field_#{@string_field1.id}_substring_gist" => 'foo',
            "field_#{@string_field2.id}_substring_gist" => 'bar'}
        end
        describe 'w both substrings by 1 parent' do
          before do
            CustomField.should_receive(:find).with("#{@string_field2.id}") { @string_field2 }
            @string_field1.should_receive(:parents_find_by_substring).with('foo') { [3, 5] }
            @string_field2.should_receive(:parents_find_by_substring).with('bar') { [5, 8] }
          end
          it { expect(@o.custom_gather_ids @params, true). to eql [5] }
        end

        describe 'w both substrings by different parents' do
          before do
            CustomField.should_receive(:find).with("#{@string_field2.id}") { @string_field2 }
            @string_field1.should_receive(:parents_find_by_substring).with('foo') { [3, 5] }
            @string_field2.should_receive(:parents_find_by_substring).with('bar') { [8, 13] }
          end
          it { expect(@o.custom_gather_ids @params, true). to eql [] }
        end

        describe 'w/o matching term' do
          before do
            @string_field1.should_receive(:parents_find_by_substring).with('foo') { [] }
            @string_field2.should_not_receive(:parents_find_by_substring)
          end
          it { expect(@o.custom_gather_ids @params, true).to eql [] }
        end
      end
    end
  end

  context '#all_agree_ids_for_find' do
    before do
      bld
      @params = {'these' => 'params'}
    end
    context 'w/o near_p' do
      describe 'w #column_gather_ids empty?' do
        before { @o.should_receive(:column_gather_ids).with(@params, false) { [] } }
        it { expect(@o.all_agree_ids_for_find @params, false).to eql [] }
      end

      context 'w/o #column_gather_ids' do
        before { @o.should_receive(:column_gather_ids).with(@params, false) { nil } }
        describe 'w #custom_gather_ids empty?' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { [] } }
          it { expect(@o.all_agree_ids_for_find @params, false).to eql [] }
        end

        describe 'w #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { [5, 8, 3] } }
          it { expect(@o.all_agree_ids_for_find @params, false).to match_array [3, 5, 8] }
        end

        describe 'w/o #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { nil } }
          it { expect(@o.all_agree_ids_for_find @params, false).to match_array [] }
        end
      end

      context 'w #column_gather_ids' do
        before { @o.should_receive(:column_gather_ids).with(@params, false) { [8, 13, 5] } }
        describe 'w #custom_gather_ids empty?' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { [] } }
          it { expect(@o.all_agree_ids_for_find @params, false).to eql [] }
        end

        describe 'w #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { [5, 8, 3] } }
          it { expect(@o.all_agree_ids_for_find @params, false).to match_array [5, 8] }
        end

        describe 'w/o #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, false) { nil } }
          it { expect(@o.all_agree_ids_for_find @params, false).to match_array [5, 8, 13] }
        end
      end
    end

    context 'w near_p' do
      describe 'w #column_gather_ids empty?' do
        before { @o.should_receive(:column_gather_ids).with(@params, true) { [] } }
        it { expect(@o.all_agree_ids_for_find @params, true).to eql [] }
      end

      context 'w/o #column_gather_ids' do
        before { @o.should_receive(:column_gather_ids).with(@params, true) { nil } }
        describe 'w #custom_gather_ids empty?' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { [] } }
          it { expect(@o.all_agree_ids_for_find @params, true).to eql [] }
        end

        describe 'w #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { [5, 8, 3] } }
          it { expect(@o.all_agree_ids_for_find @params, true).to match_array [3, 5, 8] }
        end

        describe 'w/o #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { nil } }
          it { expect(@o.all_agree_ids_for_find @params, true).to match_array [] }
        end
      end

      context 'w #column_gather_ids' do
        before { @o.should_receive(:column_gather_ids).with(@params, true) { [8, 13, 5] } }
        describe 'w #custom_gather_ids empty?' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { [] } }
          it { expect(@o.all_agree_ids_for_find @params, true).to eql [] }
        end

        describe 'w #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { [5, 8, 3] } }
          it { expect(@o.all_agree_ids_for_find @params, true).to match_array [5, 8] }
        end

        describe 'w/o #custom_gather_ids' do
          before { @o.should_receive(:custom_gather_ids).with(@params, true) { nil } }
          it { expect(@o.all_agree_ids_for_find @params, true).to match_array [5, 8, 13] }
        end
      end
    end
  end

  context '#parent_distribution' do
    before { bld }
    describe 'w ids' do
      before { @ids = [6, 6, 1, 1, 4, 3, 5, 5, 5, 5, 5, 2, 2, 2] }
      subject { @o.parent_distribution @ids }
      it do
        expect(subject).to include 1 => 2
        expect(subject).to include 2 => 3
        expect(subject).to include 3 => 1
        expect(subject).to include 4 => 1
        expect(subject).to include 5 => 5
        expect(subject).to include 6 => 2
      end
    end
    it 'w/o ids' do
      expect(@o.parent_distribution []).to be {}
    end
  end

  context '#any_agree_ids_for_find' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_ids = [13, 21]
    end
    context 'w #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [5, 8, 3, 21] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_ids).to eql [5, 8, 3, 8, 5, 34] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_ids).to eql [5, 8, 3] }
      end
    end

    context 'w/o #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [] } }
      context 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_ids).to eql [8, 5, 34] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params, @all_ids).to eql [] }
      end
    end
  end

  describe '#ids_grouped_by_agree_frequency' do
    before do
      bld
      @parent_distribution_hsh = {
        6 => 2,
        1 => 2,
        2 => 3,
        4 => 1,
        3 => 1,
        5 => 5}
    end
    subject { @o.ids_grouped_by_agree_frequency(@parent_distribution_hsh) }
    it do
      expect(subject).to match_array [[5, [5]], [3, [2]], [2, [6, 1]], [1, [4, 3]]]
      expect(subject[0][0]).to eql 5
      expect(subject[1][0]).to eql 3
      expect(subject[2][0]).to eql 2
      expect(subject[3][0]).to eql 1
    end
  end

  context '#groups_flatten' do
    before { bld }
    it { expect(@o.groups_flatten []).to eql [] }
    it { expect(@o.groups_flatten [[5, [34]], [3, [21, 55]]]).to eql [34, 21, 55] }
    it { expect(@o.groups_flatten [[5, [34]], [3, [8, 21, 55]], [2, [89, 233]], [1, [144]]]).to eql [34, 8, 21, 55, 89, 233, 144] }
  end

  context '#result_ids_by_relevance' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_ids = [3, 5, 8, 13]
      @o.should_receive(:all_agree_ids_for_find).with(@params) { @all_ids }
    end
    context 'w #all_agree_ids_few?' do
      before do
        @all_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN - 1 }
        @any_ids_w_dupes = [21, 21, 21, 34, 34, 34, 34, 34, 55, 55, 55]
        @o.should_receive(:any_agree_ids_for_find).with(@params, @all_ids) { @any_ids_w_dupes }
        @any_pd = {21 => 3, 34 => 5, 55 => 3}
        @o.should_receive(:parent_distribution).with(@any_ids_w_dupes) { @any_pd }
        @any_ids = @any_pd.keys
      end
      context 'w #any_agree_ids_few?' do
        before do
          @o.should_receive(:any_agree_ids_few?).with(@all_ids, @any_ids) { true }
          Settings.stub_chain(:search, :near_p) { true }
        end
        describe 'w substring_ids' do
          before do
            @substring_ids = [89, 144, 89]
            @o.should_receive(:all_agree_ids_for_find).with(@params, true) { @substring_ids }
            @o.should_receive(:parent_distribution).with(@substring_ids) { {89 => 2, 144 => 1} }
          end
          it { expect(@o.result_ids_by_relevance @params).to eql [3, 5, 8, 13, 34, 21, 55, 89, 144] }
        end

        describe 'w/o substring_ids' do
          before do
            @o.should_receive(:all_agree_ids_for_find).with(@params, true) { [] }
            @o.should_not_receive(:parent_distribution)
          end
          it { expect(@o.result_ids_by_relevance @params).to eql [3, 5, 8, 13, 34, 21, 55] }
        end
      end

      describe 'w/o #any_agree_ids_few?' do
        before do
          @o.should_receive(:any_agree_ids_few?).with(@all_ids, @any_ids) { false }
          @o.should_not_receive(:all_agree_ids_for_find)
        end
        it { expect(@o.result_ids_by_relevance @params).to eql [3, 5, 8, 13, 34, 21, 55] }
      end
    end

    describe 'w/o #all_agree_ids_few?' do
      before do
        @all_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN }
        @o.should_not_receive(:any_agree_ids_for_find)
      end
      it { expect(@o.result_ids_by_relevance @params).to eql @all_ids }
    end
  end

  context '::value_range_near' do
    it { expect(Search.value_range_near 0).to eql Range.new(-1.0, 1.0) }

    describe 'positive value' do
      it { expect(Search.value_range_near 1).to eql Range.new(0.0, 2.0) }
      it { expect(Search.value_range_near 14).to eql Range.new(13.0, 15.0) }
      it { expect(Search.value_range_near 15).to eql Range.new(13, 17) }
      it { expect(Search.value_range_near 16).to eql Range.new(14, 18) }
      it { expect(Search.value_range_near 100).to eql Range.new(90, 112) }
    end

    describe 'negative value' do
      it { expect(Search.value_range_near -1).to eql Range.new(-2.0, 0.0) }
      it { expect(Search.value_range_near -14).to eql Range.new(-15.0, -13.0) }
      it { expect(Search.value_range_near -15).to eql Range.new(-17, -13) }
      it { expect(Search.value_range_near -16).to eql Range.new(-18, -14) }
      it { expect(Search.value_range_near -100).to eql Range.new(-112, -90) }
    end
  end

private

  def bld
    @o = Search.new
  end
end