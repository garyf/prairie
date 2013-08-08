require 'spec_helper'

describe CheckboxBooleanField do
  describe '#type_human' do
    before { @o = CheckboxBooleanField.new }
    it 'w/o downcase' do
      expect(@o.type_human).to eql 'Checkbox field'
    end
    it 'w downcase' do
      expect(@o.type_human true).to eql 'checkbox field'
    end
  end
end
