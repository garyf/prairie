class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  has_many :person_string_gists, foreign_key: :parent_id, dependent: :destroy

  paginates_per 8

  validates :birth_year, numericality: {greater_than: 1899, less_than: 2014, only_integer: true}, allow_blank: true
  validates :email, presence: true, length: 3..254, format: {with: /@/}
  validates :height, numericality: {greater_than: 13, less_than: 89}, allow_blank: true
  validates :name_first, length: {maximum: 55}
  validates :name_last, presence: true, length: {maximum: 55}

  def self.by_name_last(page)
    order('name_last').page page
  end

  def self.id_where_case_insensitive_value(column, value)
    where("lower(#{column}) = ?", value.downcase).pluck(:id)
  end

  def self.id_where_ILIKE_value(column, value)
    where(Person.arel_table[column].matches "%#{value}%").pluck(:id)
  end

  def self.id_where_numeric_value(column, value)
    where("#{column}" => value).pluck(:id)
  end

  def self.id_where_id(ids)
    select(:id).where(id: ids)
  end

  def self.name_last_where_ids_preserve_order(ids)
    hsh = select(:id, :name_last).where(id: ids).group_by(&:id)
    ids.map { |k| hsh[k.to_i].first }
  end

  def index_on_gist_add(custom_field_id, gist)
    PersonStringGist.create(
      custom_field_id: custom_field_id,
      gist: gist.downcase,
      parent_id: id)
  end
end
