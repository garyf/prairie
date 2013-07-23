module RedisFieldValues

  extend ActiveSupport::Concern

  included do
    hash_key :field_values
  end

  def gist_store(field_id, gist)
    return field_values.delete(field_id) if gist.blank?
    field_values[field_id] = gist
  end

  def gist_fetch(field_id)
    field_values[field_id]
  end

  def custom_fields_garbage_collect_and_self_destroy
    field_values.keys.each { |field_id| remove_self_from_custom_field_parents field_id }
    field_values.clear
    self.destroy
  end

# not publicly used

  def remove_self_from_custom_field_parents(field_id) #custom_fields_garbage_collect_and_self_destroy
    redis.srem("custom_field:#{field_id}:parents", id)
  end
end
