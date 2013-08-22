class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

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
end
