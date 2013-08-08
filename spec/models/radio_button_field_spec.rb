require 'spec_helper'

describe RadioButtonField do
  describe '#type_human' do
    before { @o = RadioButtonField.new }
    it 'w/o downcase' do
      expect(@o.type_human).to eql 'Radio button field'
    end
    it 'w downcase' do
      expect(@o.type_human true).to eql 'radio button field'
    end
  end
end
