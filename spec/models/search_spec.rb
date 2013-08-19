require 'spec_helper'

describe Search do
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
    end
    context 'w #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [5, 8, 3] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [8, 13, 5] } }
        it { expect(@o.any_agree_ids_for_find @params).to match_array [[2, [5, 8]], [1, [3, 13]]] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params).to match_array [[1, [5, 8, 3]]] }
      end
    end

    context 'w/o #column_any_gather_ids' do
      before { @o.should_receive(:column_any_gather_ids).with(@params) { [] } }
      describe 'w #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [55, 8, 34, 8, 8] } }
        it { expect(@o.any_agree_ids_for_find @params).to match_array [[3, [8]], [1, [55, 34]]] }
      end

      describe 'w/o #custom_any_gather_ids' do
        before { @o.should_receive(:custom_any_gather_ids).with(@params) { [] } }
        it { expect(@o.any_agree_ids_for_find @params).to eql [] }
      end
    end
  end

private

  def bld
    @o = Search.new
  end
end