require 'spec_helper'

describe FieldSet do
  context '::validates' do
    context '#fields_enabled_qty' do
      describe 'out of range' do
        it 'low' do
          bld fields_enabled_qty: -1
          expect(@o.error_on :fields_enabled_qty).to include 'must be greater than -1'
        end
        it 'high' do
          bld fields_enabled_qty: 22
          expect(@o.error_on :fields_enabled_qty).to include 'must be less than 22'
        end
      end

      it 'w/o integer' do
        bld fields_enabled_qty: 1.5
        expect(@o.error_on :fields_enabled_qty).to include 'must be an integer'
      end
    end

    it '#name nil' do
      bld name: nil
      expect(@o.error_on :name).to include "can't be blank"
    end

    it 'w/o unique #name' do
      FactoryGirl.create(:person_field_set, name: 'Duplicate') # note different subklass
      bld name: 'Duplicate'
      expect(@o.error_on :name).to include 'has already been taken'
    end

    it '#type nil' do
      bld type: nil
      expect(@o.error_on :type).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#fields_enabled_qty nil' do
      expect_db_error { svf(bld fields_enabled_qty: nil) }
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
    @o = FactoryGirl.build(:location_field_set, options)
  end
end
