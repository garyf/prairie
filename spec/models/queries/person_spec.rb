require 'spec_helper'

describe Person do
  context '::id_where_case_insensitive_value, ::id_where_ILIKE_value' do
    context 'w 1 person' do
      before do
        @o0 = cr(name_last: 'George', email: 'vienna@example.com')
        @id0 = @o0.id
      end
      it 'w search term length equal to value length' do
        expect(Person.id_where_case_insensitive_value :name_last, 'George').to match_array [@id0]
        expect(Person.id_where_case_insensitive_value :name_last, 'george').to match_array [@id0]
        expect(Person.id_where_ILIKE_value :name_last, 'George').to match_array [@id0]
        expect(Person.id_where_ILIKE_value :name_last, 'george').to match_array [@id0]
        expect(Person.id_where_case_insensitive_value :email, 'Vienna@example.com').to match_array [@id0]
        expect(Person.id_where_case_insensitive_value :email, 'Viento@example.com').to match_array []
        expect(Person.id_where_ILIKE_value :email, 'Vienna@example.com').to match_array [@id0]
        expect(Person.id_where_ILIKE_value :email, 'Viento@example.com').to match_array []
      end

      it 'w near search term' do
        expect(Person.id_where_case_insensitive_value :name_last, 'eorge').to match_array []
        expect(Person.id_where_case_insensitive_value :name_last, 'Georg').to match_array []
        expect(Person.id_where_ILIKE_value :name_last, 'eorge').to match_array [@id0]
        expect(Person.id_where_ILIKE_value :name_last, 'Georg').to match_array [@id0]
      end

      describe 'w 2 people' do
        before do
          @o1 = cr(name_last: 'george', email: 'Vienna@example.com')
          @id1 = @o1.id
        end
        it do
          expect(Person.id_where_case_insensitive_value :name_last, 'George').to match_array [@id0, @id1]
          expect(Person.id_where_case_insensitive_value :email, 'Vienna@example.com').to match_array [@id0, @id1]
          expect(Person.id_where_ILIKE_value :name_last, 'George').to match_array [@id0, @id1]
          expect(Person.id_where_ILIKE_value :email, 'Vienna@example.com').to match_array [@id0, @id1]
        end
      end
    end
  end

  context '::id_where_value, ::id_where_numeric_range' do
    context 'w 1 person' do
      before do
        @o0 = cr(birth_year: 1980, height: 70)
        @id0 = @o0.id
      end
      it 'w search term == value' do
        expect(Person.id_where_value :birth_year, 1980).to match_array [@id0]
        expect(Person.id_where_numeric_range :birth_year, 1980).to match_array [@id0]
        expect(Person.id_where_value :height, 70).to match_array [@id0]
        expect(Person.id_where_numeric_range :height, 70).to match_array [@id0]
      end

      it 'w search term near value' do
        expect(Person.id_where_value :birth_year, 1979).to match_array []
        expect(Person.id_where_value :birth_year, 1981).to match_array []
        expect(Person.id_where_numeric_range :birth_year, 2201).to match_array [@id0]
        expect(Person.id_where_numeric_range :birth_year, 1782).to match_array [@id0]
      end

      describe 'w 2 people' do
        before do
          @o1 = cr(birth_year: 1980, height: 68)
          @id1 = @o1.id
        end
        it do
          expect(Person.id_where_value :birth_year, 1980).to match_array [@id0, @id1]
          expect(Person.id_where_value :height, 68).to match_array [@id1]
          expect(Person.id_where_numeric_range :birth_year, 1999).to match_array [@id0, @id1]
          expect(Person.id_where_numeric_range :height, 69).to match_array [@id0, @id1]
        end
      end
    end
  end

  context '::name_last_where_ids_preserve_order' do
    before do
      @person0 = c_person_cr(name_last: 'Anders')
      @person1 = c_person_cr(name_last: 'Brady')
      @person2 = c_person_cr(name_last: 'Carson')
      @person3 = c_person_cr(name_last: 'Dixon')
      @id0 = @person0.id
      @id1 = @person1.id
      @id2 = @person2.id
    end
    describe 'passing [0, 1, 2]' do
      subject { Person.name_last_where_ids_preserve_order(["#{@id0}","#{@id1}","#{@id2}"]) }
      it do
        expect(subject.length).to eql 3
        expect(subject[0].name_last).to eql 'Anders'
        expect(subject[1].name_last).to eql 'Brady'
        expect(subject[2].name_last).to eql 'Carson'
      end
    end

    describe 'passing [2, 0, 1]' do
      subject { Person.name_last_where_ids_preserve_order(["#{@id2}","#{@id0}","#{@id1}"]) }
      it do
        expect(subject.length).to eql 3
        expect(subject[0].name_last).to eql 'Carson'
        expect(subject[1].name_last).to eql 'Anders'
        expect(subject[2].name_last).to eql 'Brady'
      end
    end
  end

private

  def cr(options = {})
    FactoryGirl.create(:person, options)
  end
end
