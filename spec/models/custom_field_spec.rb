require 'spec_helper'

describe CustomField do
  context 'ranked-model' do
    it { expect(CustomField.rankers.count).to eql 1 }

    describe 'ranker options' do
      subject { CustomField.rankers[0] }
      it do
        expect(subject.class_name).to eql 'CustomField'
        expect(subject.column).to eql :row
        expect(subject.with_same).to eql :field_set_id
      end
    end

    context 'w 2 field_sets ea w 1 string field' do
      before do
        @people_field_set_id = FieldSet.create(type: 'PersonFieldSet', name: 'People').id
        @locationsfield_set_id = FieldSet.create(type: 'LocationFieldSet', name: 'Location').id
        @string_0_for_people = CustomField.create(type: 'StringField', name: 'string ppl0', field_set_id: @people_field_set_id)
        @string_0_for_locations = CustomField.create(type: 'StringField', name: 'string lcn0', field_set_id: @locationsfield_set_id)
      end
      it 'field set ranks segregated' do
        expect(@string_0_for_people.row).to eql 0
        expect(@string_0_for_locations.row).to eql 0
      end

      context 'after add of 1 numeric field to ea field set' do
        before do
          @numeric_0_for_people = CustomField.create(type: 'NumericField', name: 'numeric ppl0', field_set_id: @people_field_set_id)
          @numeric_0_for_locations = CustomField.create(type: 'NumericField', name: 'numeric lcn0', field_set_id: @locationsfield_set_id)
          @max_rank_half = 4194304
        end
        it 'field set ranks segregated' do
          expect(@numeric_0_for_people.row).to eql @max_rank_half
          expect(@numeric_0_for_locations.row).to eql @max_rank_half
        end

        context 'after add of 1 choice field to ea field set' do
          before do
            @choice_0_for_people = CustomField.create(type: 'ChoiceField', name: 'choice ppl0', field_set_id: @people_field_set_id)
            @choice_0_for_locations = CustomField.create(type: 'ChoiceField', name: 'choice lcn0', field_set_id: @locationsfield_set_id)
            @max_rank_three_fourths = 6291456
          end
          it 'field set ranks segregated' do
            expect(@choice_0_for_people.row).to eql @max_rank_three_fourths
            expect(@choice_0_for_locations.row).to eql @max_rank_three_fourths
          end

          context 'after row_position update' do
            before do
              @choice_0_for_people.update_attributes row_position: 0
              @choice_0_for_locations.update_attributes row_position: 0
              @negative_max_rank_half = -4194303
            end
            it 'field set ranks segregated' do
              expect(@choice_0_for_people.row).to eql @negative_max_rank_half
              expect(@choice_0_for_locations.row).to eql @negative_max_rank_half
            end
          end
        end
      end
    end
  end
end
