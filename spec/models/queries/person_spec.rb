require 'spec_helper'

describe Person do
  context '::id_where_case_insensitive_value, ::id_where_ILIKE_value' do
    context 'w 1 person' do
      before { @o0 = cr(name_last: 'George', email: 'vienna@example.com') }
      it 'w search term length equal to value length' do
        expect(Person.id_where_case_insensitive_value 'name_last', 'George').to match_array [@o0]
        expect(Person.id_where_case_insensitive_value 'name_last', 'george').to match_array [@o0]
        expect(Person.id_where_ILIKE_value 'name_last', 'George').to match_array [@o0]
        expect(Person.id_where_ILIKE_value 'name_last', 'george').to match_array [@o0]
        expect(Person.id_where_case_insensitive_value 'email', 'Vienna@example.com').to match_array [@o0]
        expect(Person.id_where_case_insensitive_value 'email', 'Viento@example.com').to match_array []
        expect(Person.id_where_ILIKE_value 'email', 'Vienna@example.com').to match_array [@o0]
        expect(Person.id_where_ILIKE_value 'email', 'Viento@example.com').to match_array []
      end

      it 'w substring search term' do
        expect(Person.id_where_case_insensitive_value 'name_last', 'eorge').to match_array []
        expect(Person.id_where_case_insensitive_value 'name_last', 'Georg').to match_array []
        expect(Person.id_where_ILIKE_value 'name_last', 'eorge').to match_array [@o0]
        expect(Person.id_where_ILIKE_value 'name_last', 'Georg').to match_array [@o0]
      end

      describe 'w 2 people' do
        before { @o1 = cr(name_last: 'george', email: 'Vienna@example.com') }
        it do
          expect(Person.id_where_case_insensitive_value 'name_last', 'George').to match_array [@o0, @o1]
          expect(Person.id_where_case_insensitive_value 'email', 'Vienna@example.com').to match_array [@o0, @o1]
          expect(Person.id_where_ILIKE_value 'name_last', 'George').to match_array [@o0, @o1]
          expect(Person.id_where_ILIKE_value 'email', 'Vienna@example.com').to match_array [@o0, @o1]
        end
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:person, options)
  end
end
