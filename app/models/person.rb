class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :email, :name_last, presence: true

  def self.by_name_last(page)
    order('name_last').page page
  end

  def self.id_where_case_insensitive_value(column, value)
    select(:id).where(Person.arel_table[column].matches "%#{value}%")
  end

  def self.id_where_id(ids)
    select(:id).where(id: ids)
  end

  def self.name_last_where_id_by_name_last(ids)
    select(:id, :name_last).where(id: ids).order(:name_last)
  end
end
