require 'spec_helper'

describe StringField do
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
