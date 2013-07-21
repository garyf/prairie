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
end
