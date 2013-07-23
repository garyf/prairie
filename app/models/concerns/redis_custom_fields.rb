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

  def parents_garbage_collect_and_self_destroy
    parents_gists_clear
    parents.clear
    constraints.clear
    self.destroy
  end

# not publicly used

  def constraint_store(k, v) #constraints_store
    return constraints.delete(k) if v.blank?
    constraints[k] = v
  end

  def parent_klass_downcase #parents_gists_clear
    str = field_set.type
    str.to_s[0...(str.rindex('FieldSet') || 0)].downcase # based on ActiveSupport::Inflector#deconstantize
  end

  def parents_gists_clear #parents_garbage_collect_and_self_destroy
    parents.each { |parent_id| redis.hdel("#{parent_klass_downcase}:#{parent_id}:field_values", id) }
  end
end
