class Location < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :name, presence: true

  def self.by_name(page)
    order('name').page page
  end

  def self.id_where_case_insensitive_value(column, value)
    select(:id).where("lower(#{column}) = ?", value.downcase)
  end

  def self.id_where_ILIKE_value(column, value)
    select(:id).where(Location.arel_table[column].matches "%#{value}%")
  end

  def self.id_where_id(ids)
    select(:id).where(id: ids)
  end

  def self.name_where_id_by_name(ids)
    select(:id, :name).where(id: ids).order(:name)
  end
end
