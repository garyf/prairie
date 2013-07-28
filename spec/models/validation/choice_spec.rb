require 'spec_helper'

describe Choice do
  context '::validates' do
    it '#custom_field nil' do
      bld custom_field: nil
      expect(@o.error_on :custom_field).to include "can't be blank"
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
  end

  context 'db constraints w' do
    it '#custom_field nil' do
      expect_db_error { svf(bld custom_field: nil) }
    end

    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end
  end

private

  def bld(options = {})
    @custom_field ||= FactoryGirl.build_stubbed(:custom_field)
    @o = FactoryGirl.build(:choice, {
      custom_field: @custom_field}.merge(options))
  end

  def cr(options = {})
    bld options
    @o.save
  end
end
