class Location < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :name, presence: true

  def self.by_ids(ids)
    select(:id).where(id: ids)
  end

  def self.by_name(page)
    order('name').page page
  end

  def self.name_by_ids(ids)
    select(:id, :name).where(id: ids).order(:name)
  end
end
