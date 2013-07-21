class Location < ActiveRecord::Base

  paginates_per 8

  validates :name, presence: true

  def self.by_name(page)
    order('name').page page
  end
end
