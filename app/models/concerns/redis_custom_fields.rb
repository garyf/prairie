module RedisCustomFields

  extend ActiveSupport::Concern

  included do
    hash_key :constraints
  end

  def constraint_store(k, v)
    return constraints.delete(k) if v.blank?
    constraints[k] = v
  end
end
