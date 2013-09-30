require 'spec_helper'

describe Location do
  describe '::search_results_fetch' do
    before do
      @search_cache = double('search_cache')
      result_ids = %w{ 2 3 5 }
      @locations = %w{ p2 p3 p5 }
      @search_cache.should_receive(:result_ids_fetch).with('1') { result_ids }
      Location.should_receive(:name_where_ids_preserve_order).with(result_ids) { @locations }
    end
    it { expect(Location.search_results_fetch @search_cache, '1').to eql @locations }
  end

  describe '#numeric_gist_cr' do
    before { c_location_bs }
    subject { @o.numeric_gist_cr(3, 5) }
    it do
      expect(subject.id).to be
      expect(subject.custom_field_id).to eql 3
      expect(subject.gist).to eql 5.0
      expect(subject.parent_id).to eql @o.id
    end
  end

  describe '#string_gist_cr' do
    before { c_location_bs }
    subject { @o.string_gist_cr(8, 'Foo') }
    it 'gist.downcase' do
      expect(subject.id).to be
      expect(subject.custom_field_id).to eql 8
      expect(subject.gist).to eql 'foo'
      expect(subject.parent_id).to eql @o.id
    end
  end
end
