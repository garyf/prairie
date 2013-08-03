module RedisFieldValues

  extend ActiveSupport::Concern

  included do
    hash_key :field_values
  end

  def gist_store(field_id, gist)
    index_on_gist_remove(field_id)
    return field_values.delete(field_id) if gist.blank?
    field_values[field_id] = gist
  end

  def gist_fetch(field_id)
    field_values[field_id]
  end

  def garbage_collect_and_self_destroy
    field_values.keys.each do |field_id|
      remove_self_from_custom_field_parents field_id
      index_on_gist_remove field_id
    end
    field_values.clear
    self.destroy
  end

  # before custom_field.destroy, delete all indices on gist
  def index_on_gist_delete(field_id) # field_set#index_on_gist_delete
    redis.del(index_on_gist_key field_id)
  end

# not publicly used

  def remove_self_from_custom_field_parents(field_id) #garbage_collect_and_self_destroy
    redis.srem("custom_field:#{field_id}:parents", id)
  end

  def index_on_gist_key(field_id) #index_on_gist_delete, #index_on_gist_remove
    str = gist_fetch(field_id)
    "custom_field:#{field_id}:#{str.downcase}" if str
  end

  def index_on_gist_remove(field_id) #gist_store, #garbage_collect_and_self_destroy
    key = index_on_gist_key(field_id)
    redis.srem(key, id) if key
  end
end
