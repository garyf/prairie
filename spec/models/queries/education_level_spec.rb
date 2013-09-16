require 'spec_helper'

describe EducationLevel do
  context '::name_by_row, #human_row, ::row_edit_able?' do
    before { @education_level0 = cr(name: 'High School', row_position: 0) }
    it 'w 1 level' do
      expect(@education_level0.human_row).to eql 1
      expect(EducationLevel.name_by_row[0].name).to eql 'High School'
      expect(EducationLevel.row_edit_able?).to be false
    end

    describe 'w 2 levels' do
      before { @education_level1 = cr(name: 'College', row_position: 0) }
      it do
        expect(@education_level1.human_row).to eql 1
        expect(@education_level0.human_row).to eql 2
        expect(EducationLevel.name_by_row[0].name).to eql 'College'
        expect(EducationLevel.name_by_row[1].name).to eql 'High School'
        expect(EducationLevel.row_edit_able?).to be true
      end
    end

    describe 'w 3 levels' do
      before do
        @education_level1 = cr(name: 'College', row_position: 0)
        @education_level2 = cr(name: 'Graduate', row_position: 0)
      end
      it do
        expect(@education_level2.human_row).to eql 1
        expect(@education_level1.human_row).to eql 2
        expect(@education_level0.human_row).to eql 3
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:education_level, options)
  end
end
