class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  has_many :person_string_gists, foreign_key: :parent_id, dependent: :destroy

  paginates_per 8

  validates :email, :name_last, presence: true

  def self.by_name_last(page)
    order('name_last').page page
  end

  def self.id_where_case_insensitive_value(column, value)
    select(:id).where("lower(#{column}) = ?", value.downcase)
  end

  def self.id_where_ILIKE_value(column, value)
    select(:id).where(Person.arel_table[column].matches "%#{value}%")
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
