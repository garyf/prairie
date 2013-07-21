require 'spec_helper'

describe Location do
  context '::validates w' do
    it '#name nil' do
      bld name: nil
      expect(@o.error_on :name).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end
  end

private

  def bld(options = {})
    @o = FactoryGirl.build(:location, options)
  end
end
