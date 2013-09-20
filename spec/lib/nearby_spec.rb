require 'nearby'

describe Nearby do
  context '::range_near' do
    it { expect(NearbyDoer.range_near 0).to eql Range.new(-1.0, 1.0) }

    describe 'positive value' do
      it { expect(NearbyDoer.range_near 1).to eql Range.new(0.0, 2.0) }
      it { expect(NearbyDoer.range_near 14).to eql Range.new(13.0, 15.0) }
      it { expect(NearbyDoer.range_near 15).to eql Range.new(13, 17) }
      it { expect(NearbyDoer.range_near 16).to eql Range.new(14, 18) }
      it { expect(NearbyDoer.range_near 100).to eql Range.new(90, 112) }
    end

    describe 'negative value' do
      it { expect(NearbyDoer.range_near -1).to eql Range.new(-2.0, 0.0) }
      it { expect(NearbyDoer.range_near -14).to eql Range.new(-15.0, -13.0) }
      it { expect(NearbyDoer.range_near -15).to eql Range.new(-17, -13) }
      it { expect(NearbyDoer.range_near -16).to eql Range.new(-18, -14) }
      it { expect(NearbyDoer.range_near -100).to eql Range.new(-112, -90) }
    end
  end
end

class NearbyDoer
  extend Nearby
end
