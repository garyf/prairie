require 'spec_helper'

describe Choice do
  context 'ranked-model' do
    it { expect(Choice.rankers.count).to eql 1 }

    describe 'ranker options' do
      subject { Choice.rankers[0] }
      it do
        expect(subject.column).to eql :row
        expect(subject.with_same).to eql :custom_field_id
      end
    end

    context 'w 2 select_fields ea w 1 choice' do
      before do
        @field_set_id = FieldSet.create(type: 'LocationFieldSet', name: 'Location').id
        @select_field_0_id = CustomField.create(type: 'SelectField', name: 'Colors', field_set_id: @field_set_id).id
        @select_field_1_id = CustomField.create(type: 'SelectField', name: 'Fruit', field_set_id: @field_set_id).id
        @choice_0a = Choice.create(name: 'red', custom_field_id: @select_field_0_id)
        @choice_1a = Choice.create(name: 'apple', custom_field_id: @select_field_1_id)
      end
      it 'custom field ranks segregated' do
        expect(@choice_0a.row).to eql 0
        expect(@choice_1a.row).to eql 0
      end

      context 'after add of 2nd choice to ea select field' do
        before do
          @choice_0b = Choice.create(name: 'yellow', custom_field_id: @select_field_0_id)
          @choice_1b = Choice.create(name: 'banana', custom_field_id: @select_field_1_id)
          @max_rank_half = 4194304
        end
        it 'custom field ranks segregated' do
          expect(@choice_0b.row).to eql @max_rank_half
          expect(@choice_1b.row).to eql @max_rank_half
        end

        context 'after add of 3rd choice to ea select field' do
          before do
            @choice_0c = Choice.create(name: 'blue', custom_field_id: @select_field_0_id)
            @choice_1c = Choice.create(name: 'berry', custom_field_id: @select_field_1_id)
            @max_rank_three_fourths = 6291456
          end
          it 'custom field ranks segregated' do
            expect(@choice_0c.row).to eql @max_rank_three_fourths
            expect(@choice_1c.row).to eql @max_rank_three_fourths
          end

          context 'after row_position update' do
            before do
              @choice_0c.update_attributes row_position: 0
              @choice_1c.update_attributes row_position: 0
              @negative_max_rank_half = -4194303
            end
            it 'field set ranks segregated' do
              expect(@choice_0c.row).to eql @negative_max_rank_half
              expect(@choice_0c.row).to eql @negative_max_rank_half
            end
          end
        end
      end
    end
  end

  context '#destroyable?, #name_edit_able?, #parents, #parents?' do
    context 'w name' do
      before { bld(name: 'Magenta') }
      describe 'w #parents_find_by_gist' do
        before { @custom_field.stub(:parents_find_by_gist).with('Magenta') { [5, 13] } }
        it { expect(@o.destroyable?).to be false }
        it { expect(@o.name_edit_able?).to be false }
        it { expect(@o.parents).to match_array [5, 13] }
        it { expect(@o.parents?).to be true }
      end

      describe 'w/o #parents_find_by_gist' do
        before { @custom_field.stub(:parents_find_by_gist).with('Magenta') { [] } }
        it { expect(@o.destroyable?).to be true }
        it { expect(@o.name_edit_able?).to be true }
        it { expect(@o.parents).to eql [] }
        it { expect(@o.parents?).to be false }
      end
    end

    describe 'w name blank?' do
      before do
        bld(name: '')
        @custom_field.should_not_receive(:parents_find_by_gist)
      end
      it { expect(@o.destroyable?).to be true }
      it { expect(@o.name_edit_able?).to be true }
      it { expect(@o.parents).to be nil }
      it { expect(@o.parents?).to be nil }
    end
  end

private

  def bld(options = {})
    @custom_field ||= FactoryGirl.build_stubbed(:custom_field)
    @o = FactoryGirl.build(:choice, {
      custom_field: @custom_field}.merge(options))
  end
end
