require 'spec_helper'

describe CustomField do
  context '::validates' do
    it '#enabled_p nil' do
      bld enabled_p: nil
      expect(@o.error_on :enabled_p).to include 'must be true or false'
    end

    it '#field_set nil' do
      bld field_set: nil
      expect(@o.error_on :field_set).to include "can't be blank"
    end

    it '#gist_required_present w required_p' do
      bld required_p: true
      expect(@o.error_on :gist).to include "of a required field can't be blank"
    end

    it '#name nil' do
      bld name: nil
      expect(@o.error_on :name).to include "can't be blank"
    end

    it 'w/o unique #name' do
      cr name: 'Colors'
      bld name: 'Colors'
      expect(@o.error_on :name).to include 'has already been taken'
    end

    it '#required_p nil' do
      bld required_p: nil
      expect(@o.error_on :required_p).to include 'must be true or false'
    end

    it '#type nil' do
      bld type: nil
      expect(@o.error_on :type).to include "can't be blank"
    end
  end

  context 'constraints' do
    it 'w/o numerical #length_max' do
      bld length_max: 'foo'
      expect(@o.error_on :length_max).to include 'is not a number'
    end

    it 'w/o integer #length_max' do
      bld length_max: '1.1'
      expect(@o.error_on :length_max).to include 'must be an integer'
    end

    it '#length_max < 1' do
      bld length_max: '0'
      expect(@o.error_on :length_max).to include 'must be greater than 0'
    end

    it '#length_max > 255' do
      bld length_max: '256'
      expect(@o.error_on :length_max).to include 'must be less than 256'
    end

    it 'w/o numerical #length_min' do
      bld length_min: 'foo'
      expect(@o.error_on :length_min).to include 'is not a number'
    end

    it 'w/o integer #length_min' do
      bld length_min: '1.1'
      expect(@o.error_on :length_min).to include 'must be an integer'
    end

    it '#length_min < 1' do
      bld length_min: '0'
      expect(@o.error_on :length_min).to include 'must be greater than 0'
    end

    it '#length_min > 255' do
      bld length_min: '256'
      expect(@o.error_on :length_min).to include 'must be less than 256'
    end

    it '#length_min_lte_length_max w length_min > length_max' do
      bld length_max: '21', length_min: '22'
      expect(@o.error_on :length_min).to include 'must be less than or equal to 21 (Length max)'
    end
  end

  context 'w #constraints_store', :redis do
    before do
      cr
      @o.constraints_store({
        'length_max' => '34',
        'length_min' => '3'})
    end

    it '#gist_lte_length_max w #gist length > length_max' do
      @o.gist = STR_35
      expect(@o.error_on :gist).to include 'length must be less than 35'
    end

    it '#gist_gte_length_min w #gist length < length_min' do
      @o.gist = 'ab'
      expect(@o.error_on :gist).to include 'length must be greater than 2'
    end
  end

  context 'db constraints w' do
    it '#enabled_p nil' do
      expect_db_error { svf(bld enabled_p: nil) }
    end

    it '#field_set nil' do
      expect_db_error { svf(bld field_set: nil) }
    end

    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end

    it '#required_p nil' do
      expect_db_error { svf(bld required_p: nil) }
    end

    it '#type nil' do
      expect_db_error { svf(bld type: nil) }
    end
  end

private

  def bld(options = {})
    @field_set ||= FactoryGirl.build(:person_field_set)
    @o = FactoryGirl.build(:string_field, {
      field_set: @field_set}.merge(options))
  end

  def cr(options = {})
    bld options
    @o.save
  end
end
