module RedisCustomFields

  extend ActiveSupport::Concern

  included do
    hash_key :constraints
    set :parents # ids of parents that have stored a custom_field gist
  end

  # constraints not editable once a parent exists
  def parent?
    !parents.empty?
  end

  def gist_store(parent, params_white)
    self.gist = params_white['gist']
    return false unless self.valid?
    parent.gist_store(id, gist)
    parents << parent.id
  end

  def gist_fetch(parent)
    self.gist = parent.gist_fetch(id)
    self.parent_id = parent.id
    self
  end

  def constraint_store(k, v)
    return constraints.delete(k) if v.blank?
    constraints[k] = v
  end
end
