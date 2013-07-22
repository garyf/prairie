require 'spec_helper'

describe StringField do
  context '::validates' do
    it '#field_set nil' do
      bld field_set: nil
      expect(@o.error_on :field_set).to include "can't be blank"
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

    it '#type nil' do
      bld type: nil
      expect(@o.error_on :type).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#field_set nil' do
      expect_db_error { svf(bld field_set: nil) }
    end

    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end

    it '#type nil' do
      expect_db_error { svf(bld type: nil) }
    end
  end

private

  def bld(options = {})
    @field_set ||= FactoryGirl.build_stubbed(:person_field_set)
    @o = FactoryGirl.build(:string_field, {
      field_set: @field_set}.merge(options))
  end

  def cr(options = {})
    bld options
    @o.save
  end
end
