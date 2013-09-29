require 'spec_helper'

describe NumericField do
  context '::enabled' do
    before { numeric_field_w_field_set_cr(enabled_p: false) }
    it { expect(NumericField.enabled).to match_array [] }

    describe 'w 1 numeric_field enabled' do
      before { @o = numeric_field_w_field_set_cr }
      it { expect(NumericField.enabled).to match_array [@o] }
    end
  end

  describe '#parents_find_by_gist, #parents_find_near' do
    before do
      person_numeric_gist_cr(gist: 21, parent_id: 1)
      person_numeric_gist_cr(gist: 55, parent_id: 2)
      person_numeric_gist_cr(gist: 21, parent_id: 5)
    end
    it do
      expect(@o.parents_find_by_gist '21').to match_array [1, 5]
      expect(@o.parents_find_by_gist '55').to match_array [2]
      expect(@o.parents_find_by_gist '99').to eql []
      expect(@o.parents_find_near '24').to match_array [1, 5]
      expect(@o.parents_find_near '19').to match_array [1, 5]
      expect(@o.parents_find_near '55').to match_array [2]
      expect(@o.parents_find_near '99').to match_array []
    end
  end

  context '#index_on_gist_update' do
    before do
      person_numeric_gist_cr(gist: 3, parent_id: 1)
      @o.gist = 5
    end
    describe 'w numeric_gist' do
      subject { @o.index_on_gist_update 1 }
      it 'updates .gist' do
        expect(subject).to be true
        expect(@o.numeric_gists.where_parent_id(1)[0].gist).to eql 5.0
      end
    end

    describe 'w numeric_gist duplicate' do
      before { person_numeric_gist_cr(gist: 8, parent_id: 1) }
      it { expect { @o.index_on_gist_update 1 }.to raise_error CustomField::GistDuplicate }
    end

    it 'w/o numeric_gist' do
      expect(@o.index_on_gist_update 2).to be nil
      expect(@o.numeric_gists.where(parent_id: 1)[0].gist).to eql 3.0
    end
  end

private

  def numeric_field_w_field_set_cr(options = {})
    @field_set ||= FactoryGirl.create(:location_field_set)
    FactoryGirl.create(:numeric_field, {
      field_set: @field_set}.merge(options))
  end

  def cr(options = {})
    FactoryGirl.create(:person_numeric_field, options)
  end

  def person_numeric_gist_cr(options = {})
    @o ||= cr
    FactoryGirl.create(:person_numeric_gist, {
      numeric_field: @o}.merge(options))
  end
end
