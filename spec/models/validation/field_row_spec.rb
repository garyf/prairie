require 'spec_helper'

describe FieldRow do
  context '::validates w' do
    it '#custom_field nil' do
      bld custom_field_id: nil
      expect(@o.error_on :custom_field).to include "can't be blank"
    end

    it '#field_set nil' do
      bld field_set_id: nil
      expect(@o.error_on :field_set).to include "can't be blank"
    end
  end

  context 'db constraints w' do
    it '#row nil' do
      expect_db_error { svf(bld row: nil) }
    end
  end

private

  def bld(options = {})
    @o = FactoryGirl.build(:person_string_field_row, options)
  end
end
