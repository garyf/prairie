class StringField < CustomField

  validates :length_max, :length_min, allow_blank: true, numericality: {greater_than: 0, less_than: 256, only_integer: true}
  validate :length_min_lte_length_max

  attr_accessor :length_max, :length_min

  CONSTRAINTS = [
    'length_max',
    'length_min']

  CHARACTER_VARYING_255 = 255

  def constraints_store(params_white, field_set_id = nil)
    field_row_create(field_set_id) if field_set_id
    CONSTRAINTS.each { |k| constraint_store(k, params_white.delete(k)) } unless parent?
  end

  def constraints_fetch
    self.length_max = constraints['length_max'] || CHARACTER_VARYING_255
    self.length_min = constraints['length_min'] || 1
    self
  end

private

  def length_min_lte_length_max
    return if length_max.blank? || length_min.blank?
    errors.add(:length_min, "must be less than or equal to #{length_max} (Length max)") if length_min.to_i > length_max.to_i
  end
end
