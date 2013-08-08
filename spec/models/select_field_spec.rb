require 'spec_helper'

describe SelectField do
  describe '#type_human' do
    before { @o = SelectField.new }
    it 'w/o downcase' do
      expect(@o.type_human).to eql 'Select list field'
    end
    it 'w downcase' do
      expect(@o.type_human true).to eql 'select list field'
    end
  end
end
