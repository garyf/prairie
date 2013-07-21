class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :email, :name_last, presence: true

  def self.by_name_last(page)
    order('name_last').page page
  end
end
