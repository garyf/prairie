class NumericField < CustomField

  has_many :numeric_gists, foreign_key: :custom_field_id, dependent: :destroy

  validates :gist, :value_max, :value_min, numericality: true, allow_blank: true
  validate :value_min_lte_value_max, :gist_only_integer, :gist_within_range

  attr_accessor :only_integer_p, :value_max, :value_min

  CONSTRAINTS = [
    'only_integer_p',
    'value_max',
    'value_min']

  def constraints_store(params_white)
    CONSTRAINTS.each { |k| constraint_store(k, params_white.delete(k)) } unless parent?
  end

  def constraints_fetch
    self.only_integer_p = constraints['only_integer_p']
    self.value_max = constraints['value_max']
    self.value_min = constraints['value_min']
    self
  end

  def index_on_gist_add(parent)
    parent.numeric_gist_cr(id, gist)
  end

  def parents_find_by_gist(nbr)
    numeric_gists.parent_id_where_gist(nbr)
  end

  def parents_find_near(nbr)
    numeric_gists.parent_id_where_numeric_range(nbr)
  end

  def index_on_gist_update(parent_id)
    postgres_index_on_gist_update(numeric_gists.where_parent_id parent_id)
  end

  def type_human(downcase_p = false)
    str = 'Numeric field'
    downcase_p ? str.downcase : str
  end

private

  def value_min_lte_value_max
    validate_min_lte_max(:value_min, value_max, value_min, 'Value')
  end

  def gist_only_integer
    return if gist.blank?
    return unless constraints['only_integer_p'] == '1' # based on ActiveModel::Validations::NumericalityValidator#parse_raw_value_as_an_integer
    errors.add(:gist, 'value must be an integer') unless gist =~ /\A[+-]?\d+\Z/
  end

  def gist_gte_value_min
    str = constraints['value_min']
    return if str.blank?
    self.value_min = str.to_f
    errors.add(:gist, "value must be greater than or equal to #{value_min}") if gist.to_f < value_min
  end

  def gist_within_range
    return if gist.blank?
    str = constraints['value_max']
    return gist_gte_value_min if str.blank?
    self.value_max = str.to_f
    gist.to_f > value_max ? errors.add(:gist, "value must be less than or equal to #{value_max}") : gist_gte_value_min
  end
end
