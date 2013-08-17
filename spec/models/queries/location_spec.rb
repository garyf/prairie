require 'spec_helper'

describe Location do
  context '::id_where_case_insensitive_value, ::id_where_ILIKE_value' do
    context 'w 1 location' do
      before { @o0 = cr(name: 'Oxford', description: 'seaside') }
      it 'w search term length equal to value length' do
        expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@o0]
        expect(Location.id_where_case_insensitive_value 'name', 'oxford').to match_array [@o0]
        expect(Location.id_where_ILIKE_value 'name', 'Oxford').to match_array [@o0]
        expect(Location.id_where_ILIKE_value 'name', 'oxford').to match_array [@o0]
        expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@o0]
        expect(Location.id_where_case_insensitive_value 'description', 'Suburbs').to match_array []
        expect(Location.id_where_ILIKE_value 'description', 'Seaside').to match_array [@o0]
        expect(Location.id_where_ILIKE_value 'description', 'Suburbs').to match_array []
      end

      it 'w substring search term' do
        expect(Location.id_where_case_insensitive_value 'name', 'xford').to match_array []
        expect(Location.id_where_case_insensitive_value 'name', 'Oxfor').to match_array []
        expect(Location.id_where_ILIKE_value 'name', 'xford').to match_array [@o0]
        expect(Location.id_where_ILIKE_value 'name', 'Oxfor').to match_array [@o0]
      end

      describe 'w 2 locations' do
        before { @o1 = cr(name: 'oxford', description: 'Seaside') }
        it do
          expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@o0, @o1]
          expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@o0, @o1]
          expect(Location.id_where_ILIKE_value 'name', 'Oxford').to match_array [@o0, @o1]
          expect(Location.id_where_ILIKE_value 'description', 'Seaside').to match_array [@o0, @o1]
        end
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:location, options)
  end
end
