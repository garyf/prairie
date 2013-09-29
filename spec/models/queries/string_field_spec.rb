require 'spec_helper'

describe StringField do
  context '::enabled' do
    before { string_field_w_field_set_cr(enabled_p: false) }
    it { expect(StringField.enabled).to match_array [] }

    describe 'w 1 string_field enabled' do
      before { @o = string_field_w_field_set_cr }
      it { expect(StringField.enabled).to match_array [@o] }
    end
  end

  describe '#parents_find_by_gist, #parents_find_near' do
    before do
      person_string_gist_cr(gist: 'abcdef', parent_id: 1)
      person_string_gist_cr(gist: 'defghi', parent_id: 2)
      person_string_gist_cr(gist: 'abcdef', parent_id: 5)
    end
    it do
      expect(@o.parents_find_by_gist 'ABCDEF').to match_array [1, 5]
      expect(@o.parents_find_by_gist 'DEFGHI').to match_array [2]
      expect(@o.parents_find_by_gist 'DEF').to eql []
      expect(@o.parents_find_near 'ABCDEF').to match_array [1, 5]
      expect(@o.parents_find_near 'DEFGHI').to match_array [2]
      expect(@o.parents_find_near 'DEF').to match_array [1, 2, 5]
    end
  end

  context '#index_on_gist_update' do
    before do
      person_string_gist_cr(gist: 'foo', parent_id: 1)
      @o.gist = 'bar'
    end
    describe 'w string_gist' do
      subject { @o.index_on_gist_update 1 }
      it 'updates .gist' do
        expect(subject).to be true
        expect(@o.string_gists.where_parent_id(1)[0].gist).to eql 'bar'
      end
    end

    describe 'w string_gist duplicate' do
      before { person_string_gist_cr(gist: 'baz', parent_id: 1) }
      it { expect { @o.index_on_gist_update 1 }.to raise_error CustomField::GistDuplicate }
    end

    it 'w/o string_gist' do
      expect(@o.index_on_gist_update 2).to be nil
      expect(@o.string_gists.where(parent_id: 1)[0].gist).to eql 'foo'
    end
  end

private

  def string_field_w_field_set_cr(options = {})
    @field_set ||= FactoryGirl.create(:location_field_set)
    FactoryGirl.create(:string_field, {
      field_set: @field_set}.merge(options))
  end

  def cr(options = {})
    FactoryGirl.create(:person_string_field, options)
  end

  def person_string_gist_cr(options = {})
    @o ||= cr
    FactoryGirl.create(:person_string_gist, {
      string_field: @o}.merge(options))
  end
end
