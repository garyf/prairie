class CustomField < ActiveRecord::Base

  include Redis::Objects
  include RedisCustomFields

  belongs_to :field_set

end
