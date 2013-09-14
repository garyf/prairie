require 'spec_helper'

describe Person do
  context '::validates w' do
    context '#birth_year' do
      it 'out of range high' do
        bld birth_year: 2015
        expect(@o.error_on :birth_year).to include 'must be less than 2015'
      end
      it 'w/o integer' do
        bld birth_year: 2013.5
        expect(@o.error_on :birth_year).to include 'must be an integer'
      end
    end

    context '#email' do
      it 'blank' do
        bld email: ''
        expect(@o.error_on :email).to include "can't be blank"
      end

      context 'length out of range' do
        it 'low' do
          bld email: '@a'
          expect(@o.error_on :email).to include "is too short (minimum is 3 characters)"
        end
        it 'high' do
          bld email: EMAIL_255
          expect(@o.error_on :email).to include "is too long (maximum is 254 characters)"
        end
      end

      it 'format w/o @' do
        bld email: 'abc'
        expect(@o.error_on :email).to include "is invalid"
      end
    end

    context '#height' do
      describe 'out of range' do
        it 'low' do
          bld height: 13
          expect(@o.error_on :height).to include 'must be greater than 13'
        end
        it 'high' do
          bld height: 89
          expect(@o.error_on :height).to include 'must be less than 89'
        end
      end
    end

    it '#name_first length too long' do
      bld name_first: STR_56
      expect(@o.error_on :name_first).to include "is too long (maximum is 55 characters)"
    end

    context '#name_last' do
      it 'blank' do
        bld name_last: ''
        expect(@o.error_on :name_last).to include "can't be blank"
      end
      it 'length too long' do
        bld name_last: STR_56
        expect(@o.error_on :name_last).to include "is too long (maximum is 55 characters)"
      end
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
