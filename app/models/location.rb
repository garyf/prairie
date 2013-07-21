class Location < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :name, presence: true

  def self.by_name(page)
    order('name').page page
  end
end
