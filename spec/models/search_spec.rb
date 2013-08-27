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

  context '#any_agree_ids' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_ids = [13, 21]
    end
    context 'w #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [5, 8, 3, 21] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.any_agree_ids @params, @all_ids).to eql [5, 8, 3, 8, 5, 34] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids @params, @all_ids).to eql [5, 8, 3] }
      end
    end

    context 'w/o #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [] } }
      context 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.any_agree_ids @params, @all_ids).to eql [8, 5, 34] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids @params, @all_ids).to eql [] }
      end
    end
  end

  context '#substring_agree_ids' do
    before do
      bld
      @params = {'these' => 'params'}
      @all_ids = [13]
      @any_ids = [21]
    end
    context 'w #column_substring_gather_ids' do
      before { @o.should_receive(:column_substring_gather_ids).with(@params) { [5, 8, 3, 21] } }
      describe 'w #custom_substring_gather_ids' do
        before { @o.should_receive(:custom_substring_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.substring_agree_ids @params, @all_ids, @any_ids).to eql [5, 8, 3, 8, 5, 34] }
      end

      describe 'w/o #custom_substring_gather_ids' do
        before { @o.should_receive(:custom_substring_gather_ids).with(@params) { [] } }
        it { expect(@o.substring_agree_ids @params, @all_ids, @any_ids).to eql [5, 8, 3] }
      end
    end

    context 'w/o #column_substring_gather_ids' do
      before { @o.should_receive(:column_substring_gather_ids).with(@params) { [] } }
      context 'w #custom_substring_gather_ids' do
        before { @o.should_receive(:custom_substring_gather_ids).with(@params) { [8, 13, 5, 34] } }
        it { expect(@o.substring_agree_ids @params, @all_ids, @any_ids).to eql [8, 5, 34] }
      end

      describe 'w/o #custom_substring_gather_ids' do
        before { @o.should_receive(:custom_substring_gather_ids).with(@params) { [] } }
        it { expect(@o.substring_agree_ids @params, @all_ids, @any_ids).to eql [] }
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
        @any_agree_ids = [21, 21, 21, 34, 34, 34, 34, 34, 55, 55, 55]
        @o.should_receive(:any_agree_ids).with(@params, @all_ids) { @any_agree_ids }
        @any_pd = {21 => 3, 34 => 5, 55 => 3}
        @o.should_receive(:parent_distribution).with(@any_agree_ids) { @any_pd }
        @any_ids = @any_pd.keys
      end
      describe 'w #any_agree_ids_few?' do
        before do
          @o.should_receive(:any_agree_ids_few?).with(@all_ids, @any_ids) { true }
          @substring_ids = [89, 144, 89]
          @o.should_receive(:substring_agree_ids).with(@params, @all_ids, @any_ids) { @substring_ids }
          @o.should_receive(:parent_distribution).with(@substring_ids) { {89 => 2, 144 => 1} }
        end
        it { expect(@o.result_ids_by_relevance @params).to eql [3, 5, 8, 13, 34, 21, 55, 89, 144] }
      end

      describe 'w/o #any_agree_ids_few?' do
        before do
          @o.should_receive(:any_agree_ids_few?).with(@all_ids, @any_ids) { false }
          @o.should_not_receive(:substring_agree_ids)
        end
        it { expect(@o.result_ids_by_relevance @params).to eql [3, 5, 8, 13, 34, 21, 55] }
      end
    end

    describe 'w/o #all_agree_ids_few?' do
      before do
        @all_ids.should_receive(:length) { Search::RESULTS_COUNT_MIN }
        @o.should_not_receive(:any_agree_ids)
      end
      it { expect(@o.result_ids_by_relevance @params).to eql [@all_ids] }
    end
  end

private

  def bld
    @o = Search.new
  end
end