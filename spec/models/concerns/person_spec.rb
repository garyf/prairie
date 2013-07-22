require 'spec_helper'

describe Person do
  context '#gist_store, #gist_fetch', :redis do
    before do
      c_person_bs
      @field_id = '3'
    end
    context 'w gist' do
      before { @o.gist_store(@field_id, 'foo') }
      it { expect(@o.gist_fetch @field_id).to eql 'foo'}
    end
    context 'w/o gist' do
      before { @o.gist_store(@field_id, '') }
      it { expect(@o.gist_fetch @field_id).to be nil }
    end
  end
end
