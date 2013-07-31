class Person < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  paginates_per 8

  validates :email, :name_last, presence: true

  def self.by_name_last(page)
    order('name_last').page page
  end

  def self.name_last_by_ids(ids)
    select(:id, :name_last).where(id: ids).order(:name_last)
  end
end
