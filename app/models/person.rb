class Person < ActiveRecord::Base

  extend Nearby
  extend ParentQuery
  include Redis::Objects
  include RedisFieldValues

  belongs_to :education_level
  has_many :person_numeric_gists, foreign_key: :parent_id, dependent: :destroy
  has_many :person_string_gists, foreign_key: :parent_id, dependent: :destroy

  paginates_per Settings.person.paginates_per

  validates :birth_year, numericality: {less_than: 2015, only_integer: true}, allow_blank: true
  validates :email, presence: true, length: 3..254, format: {with: /@/}
  validates :height, numericality: {greater_than: 13, less_than: 89}, allow_blank: true
  validates :male_p, inclusion: {in: [true, false], message: 'must be true or false'}
  validates :name_first, length: {maximum: 55}
  validates :name_last, presence: true, length: {maximum: 55}

  def self.by_name_last(page)
    order('name_last').page page
  end

  def self.id_where_ILIKE_value(column, value)
    where(Person.arel_table[column].matches "%#{value}%").pluck(:id)
  end

  def self.name_last_where_ids_preserve_order(ids)
    column_where_ids_preserve_order(:name_last, ids)
  end

  def self.search_results_fetch(search_cache, page)
    name_last_where_ids_preserve_order(search_cache.result_ids_fetch page)
  end

  def numeric_gist_cr(custom_field_id, gist)
    PersonNumericGist.create(
      custom_field_id: custom_field_id,
      gist: gist,
      parent_id: id)
  end

  def string_gist_cr(custom_field_id, gist)
    PersonStringGist.create(
      custom_field_id: custom_field_id,
      gist: gist.downcase,
      parent_id: id)
  end
end
