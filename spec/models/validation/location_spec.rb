require 'spec_helper'

describe Location do
  context '::validates w' do
    it '#description length too long' do
      bld description: STR_256
      expect(@o.error_on :description).to include "is too long (maximum is 255 characters)"
    end

    context '#elevation_feet' do
      describe 'out of range' do
        it 'low' do
          bld elevation_feet: -1
          expect(@o.error_on :elevation_feet).to include 'must be greater than -1'
        end
        it 'high' do
          bld elevation_feet: 30000
          expect(@o.error_on :elevation_feet).to include 'must be less than 30000'
        end
      end

      it 'w/o integer' do
        bld elevation_feet: 1.5
        expect(@o.error_on :elevation_feet).to include 'must be an integer'
      end
    end

    context '#lot_acres' do
      describe 'out of range' do
        it 'low' do
          bld lot_acres: 0
          expect(@o.error_on :lot_acres).to include 'must be greater than 0'
        end
        it 'high' do
          bld lot_acres: 9999999
          expect(@o.error_on :lot_acres).to include 'must be less than 9999999'
        end
      end
    end

    context '#name' do
      it 'blank' do
        bld name: ''
        expect(@o.error_on :name).to include "can't be blank"
      end
      it 'length too long' do
        bld name: STR_56
        expect(@o.error_on :name).to include "is too long (maximum is 55 characters)"
      end
    end

    it '#public_p nil' do
      bld public_p: nil
      expect(@o.error_on :public_p).to include 'must be true or false'
    end
  end

  context 'db constraints w' do
    it '#name nil' do
      expect_db_error { svf(bld name: nil) }
    end

    it '#public_p nil' do
      expect_db_error { svf(bld public_p: nil) }
    end
  end

private

  def bld(options = {})
    @o = FactoryGirl.build(:location, options)
  end
end
