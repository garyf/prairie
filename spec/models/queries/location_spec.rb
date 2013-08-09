require 'spec_helper'

describe Location do
  context '::id_where_case_insensitive_value' do
    before { @o0 = cr(name: 'Oxford', description: 'seaside') }
    it 'w 1 location' do
      expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@o0]
      expect(Location.id_where_case_insensitive_value 'name', 'oxford').to match_array [@o0]
      expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@o0]
      expect(Location.id_where_case_insensitive_value 'description', 'seaside').to match_array [@o0]
      expect(Location.id_where_case_insensitive_value 'name', 'baz').to match_array []
    end

    describe 'w 2 locations' do
      before { @o1 = cr(name: 'oxford', description: 'Seaside') }
      it do
        expect(Location.id_where_case_insensitive_value 'name', 'Oxford').to match_array [@o0, @o1]
        expect(Location.id_where_case_insensitive_value 'name', 'oxford').to match_array [@o0, @o1]
        expect(Location.id_where_case_insensitive_value 'description', 'Seaside').to match_array [@o0, @o1]
        expect(Location.id_where_case_insensitive_value 'description', 'seaside').to match_array [@o0, @o1]
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:location, options)
  end
end
