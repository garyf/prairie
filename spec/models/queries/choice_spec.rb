require 'spec_helper'

describe Choice do
  context '#name_by_row, #human_row' do
    before { @choice0 = choice_cr(name: 'Apple', row_position: 0) }
    it 'w 1 choice' do
      expect(Choice.name_by_row[0].name).to eql 'Apple'
      expect(@choice0.human_row).to eql 1
    end

    describe 'w 2 choicees' do
      before { @choice1 = choice_cr(name: 'Banana', row_position: 0) }
      it do
        expect(@choice1.human_row).to eql 1
        expect(@choice0.human_row).to eql 2
        expect(Choice.name_by_row[0].name).to eql 'Banana'
        expect(Choice.name_by_row[1].name).to eql 'Apple'
      end
    end

    describe 'w 3 custom_fields' do
      before do
        @choice1 = choice_cr(name: 'Banana', row_position: 0)
        @choice2 = choice_cr(name: 'Cherry', row_position: 0)
      end
      it do
        expect(@choice2.human_row).to eql 1
        expect(@choice1.human_row).to eql 2
        expect(@choice0.human_row).to eql 3
        expect(Choice.name_by_row[0].name).to eql 'Cherry'
        expect(Choice.name_by_row[1].name).to eql 'Banana'
        expect(Choice.name_by_row[2].name).to eql 'Apple'
      end
    end
  end

private

  def custom_field_cr
    @custom_field = FactoryGirl.create(:location_numeric_field)
  end

  def choice_cr(options = {})
    @custom_field ||= custom_field_cr
    FactoryGirl.create(:choice, {
      custom_field: @custom_field}.merge(options))
  end
end