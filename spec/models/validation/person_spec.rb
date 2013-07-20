require 'spec_helper'

describe Person do
  context '::validates w' do
    it '#email nil' do
      bld email: nil
      expect(@o.error_on :email).to include "can't be blank"
    end

    it '#name_last nil' do
      bld name_last: nil
      expect(@o.error_on :name_last).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#email nil' do
      expect_db_error { svf(bld email: nil) }
    end

    it '#name_last nil' do
      expect_db_error { svf(bld name_last: nil) }
    end
  end

private

  def bld(options = {})
    @o = FactoryGirl.build(:person, options)
  end
end
