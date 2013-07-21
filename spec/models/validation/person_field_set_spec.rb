require 'spec_helper'

describe PersonFieldSet do
  context '::validates w' do
    it '#name nil' do
      bld name: nil
      expect(@o.error_on :name).to include "can't be blank"
    end

    it 'w/o unique #name' do
      FactoryGirl.create(:location_field_set, name: 'Duplicate') # note different subklass
      bld name: 'Duplicate'
      expect(@o.error_on :name).to include 'has already been taken'
    end

    it '#type nil' do
      bld type: nil
      expect(@o.error_on :type).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end

    it '#type nil' do
      expect_db_error { svf(bld type: nil) }
    end
  end

private

  def bld(options = {})
    @o = FactoryGirl.build(:person_field_set, options)
  end
end
