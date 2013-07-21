class StringField < CustomField

  attr_accessor :length_max, :length_min

  CONSTRAINTS = [
    'length_max',
    'length_min']

  def constraints_store(params_white, field_set_id = nil)
    field_row_create(field_set_id) if field_set_id
    CONSTRAINTS.each { |k| constraint_store(k, params_white.delete(k)) }
  end

  def constraints_fetch
    self.length_max = constraints['length_max']
    self.length_min = constraints['length_min']
    self
  end
end
