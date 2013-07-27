class NumericField < CustomField

  attr_accessor :only_integer_p, :value_max, :value_min

  CONSTRAINTS = [
    'only_integer_p',
    'value_max',
    'value_min']

  validates :gist, :value_max, :value_min, numericality: true, allow_blank: true
  validate :value_min_lte_value_max, :gist_only_integer, :gist_lte_value_max, :gist_gte_value_min

  def constraints_store(params_white)
    CONSTRAINTS.each { |k| constraint_store(k, params_white.delete(k)) } unless parent?
  end

  def constraints_fetch
    self.only_integer_p = constraints['only_integer_p']
    self.value_max = constraints['value_max']
    self.value_min = constraints['value_min']
    self
  end

private

  def value_min_lte_value_max
    return if value_max.blank? || value_min.blank?
    errors.add(:value_min, "must be less than or equal to #{value_max} (Value max)") if value_min.to_i > value_max.to_i
  end

  def gist_only_integer
    return if gist.blank?
    return unless constraints['only_integer_p'] == '1' # based on ActiveModel::Validations::NumericalityValidator#parse_raw_value_as_an_integer
    errors.add(:gist, 'value must be an integer') unless gist =~ /\A[+-]?\d+\Z/
  end

  def gist_lte_value_max
    return if gist.blank?
    str = constraints['value_max']
    return if str.blank?
    self.value_max = str.to_f
    errors.add(:gist, "value must be less than or equal to #{value_max}") if gist.to_f > value_max
  end

  def gist_gte_value_min
    return if gist.blank?
    str = constraints['value_min']
    return if str.blank?
    self.value_min = str.to_f
    errors.add(:gist, "value must be greater than or equal to #{value_min}") if gist.to_f < value_min
  end
end
