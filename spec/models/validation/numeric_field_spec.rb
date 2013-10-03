require 'spec_helper'

describe NumericField do
  context '::validates' do
    it 'w/o numerical #gist', :redis do
      cr
      @o.gist = 'foo'
      expect(@o.error_on :gist).to include 'is not a number'
    end
  end

  context 'constraints' do
    it 'w/o numerical #value_max' do
      bld value_max: 'foo'
      expect(@o.error_on :value_max).to include 'is not a number'
    end

    it 'w/o numerical #value_min' do
      bld value_min: 'foo'
      expect(@o.error_on :value_min).to include 'is not a number'
    end

    it '#value_min_lte_value_max w value_min > value_max' do
      bld value_max: '21', value_min: '22'
      expect(@o.error_on :value_min).to include 'must be less than or equal to 21 (Value max)'
    end
  end

  context 'w #constraints_store', :redis do
    before do
      cr
      @o.constraints_store({
        'only_integer_p' => '1',
        'value_max' => '144.7',
        'value_min' => '-13.5'})
    end

    it '#gist_only_integer w/o integer #gist' do
      @o.gist = '3.14'
      expect(@o.error_on :gist).to include 'must be an integer'
    end

    it '#gist_within_range w #gist > value_max' do
      @o.gist = '145'
      expect(@o.error_on :gist).to include 'must be less than or equal to 144.7'
    end

    it '#gist_within_range w #gist < value_min' do
      @o.gist = '-14'
      expect(@o.error_on :gist).to include 'must be greater than or equal to -13.5'
    end
  end

private

  def bld(options = {})
    @field_set ||= FactoryGirl.build(:person_field_set)
    @o = FactoryGirl.build(:numeric_field, {
      field_set: @field_set}.merge(options))
  end

  def cr(options = {})
    bld options
    @o.save
  end
end
