require 'spec_helper'

describe Location do
  context '::id_where_case_insensitive_value, ::id_where_ILIKE_value' do
    context 'w 1 location' do
      before do
        @o0 = cr(name: 'Oxford', description: 'seaside')
        @id0 = @o0.id
      end
      it 'w search term length equal to value length' do
        expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@id0]
        expect(Location.id_where_case_insensitive_value 'name', 'oxford').to match_array [@id0]
        expect(Location.id_where_ILIKE_value 'name', 'Oxford').to match_array [@id0]
        expect(Location.id_where_ILIKE_value 'name', 'oxford').to match_array [@id0]
        expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@id0]
        expect(Location.id_where_case_insensitive_value 'description', 'Suburbs').to match_array []
        expect(Location.id_where_ILIKE_value 'description', 'Seaside').to match_array [@id0]
        expect(Location.id_where_ILIKE_value 'description', 'Suburbs').to match_array []
      end

      it 'w near search term' do
        expect(Location.id_where_case_insensitive_value 'name', 'xford').to match_array []
        expect(Location.id_where_case_insensitive_value 'name', 'Oxfor').to match_array []
        expect(Location.id_where_ILIKE_value 'name', 'xford').to match_array [@id0]
        expect(Location.id_where_ILIKE_value 'name', 'Oxfor').to match_array [@id0]
      end

      describe 'w 2 locations' do
        before do
          @o1 = cr(name: 'oxford', description: 'Seaside')
          @id1 = @o1.id
        end
        it do
          expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@id0, @id1]
          expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@id0, @id1]
          expect(Location.id_where_ILIKE_value 'name', 'Oxford').to match_array [@id0, @id1]
          expect(Location.id_where_ILIKE_value 'description', 'Seaside').to match_array [@id0, @id1]
        end
      end
    end
  end

  context '::name_where_ids_preserve_order' do
    before do
      @location0 = c_location_cr(name: 'Annapolis', description: 'seaport')
      @location1 = c_location_cr(name: 'Baltimore', description: 'industrial')
      @location2 = c_location_cr(name: 'Camden', description: 'seaport')
      @location3 = c_location_cr(name: 'Denver', description: 'mountains')
      @id0 = @location0.id
      @id1 = @location1.id
      @id2 = @location2.id
    end
    describe 'passing [0, 1, 2]' do
      subject { Location.name_where_ids_preserve_order(["#{@id0}","#{@id1}","#{@id2}"]) }
      it do
        expect(subject.length).to eql 3
        expect(subject[0].name).to eql 'Annapolis'
        expect(subject[1].name).to eql 'Baltimore'
        expect(subject[2].name).to eql 'Camden'
      end
    end

    describe 'passing [2, 0, 1]' do
      subject { Location.name_where_ids_preserve_order(["#{@id2}","#{@id0}","#{@id1}"]) }
      it do
        expect(subject.length).to eql 3
        expect(subject[0].name).to eql 'Camden'
        expect(subject[1].name).to eql 'Annapolis'
        expect(subject[2].name).to eql 'Baltimore'
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:location, options)
  end
end
