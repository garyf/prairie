class StringField < CustomField

  has_many :string_gists, foreign_key: :custom_field_id, dependent: :destroy

  validates :length_max, :length_min, allow_blank: true, numericality: {greater_than: 0, less_than: 256, only_integer: true}
  validate :length_min_lte_length_max, :gist_lte_length_max, :gist_gte_length_min

  attr_accessor :length_max, :length_min

  CONSTRAINTS = [
    'length_max',
    'length_min']

  CHARACTER_VARYING_255 = 255

  class StringGistDuplicate < StandardError ; end

  def constraints_store(params_white)
    CONSTRAINTS.each { |k| constraint_store(k, params_white.delete(k)) } unless parent?
  end

  def constraints_fetch
    self.length_max = constraints['length_max'] || CHARACTER_VARYING_255
    self.length_min = constraints['length_min'] || 1
    self
  end

  def index_on_gist_add(parent)
    parent.index_on_gist_add(id, gist)
  end

  def parents_find_by_gist(str)
    string_gists.parent_id_where_gist(str.downcase)
  end

  def parents_find_near(str)
    string_gists.parent_id_where_ILIKE_gist(str)
  end

  def index_on_gist_update(parent_id)
    rltn = string_gists.where_parent_id(parent_id)
    raise StringGistDuplicate if rltn.count > 1
    o = rltn[0]
    return unless o
    o.update_attributes(gist: gist)
    false # no redis index is awaiting removal
  end

private

  def length_min_lte_length_max
    return if length_max.blank? || length_min.blank?
    errors.add(:length_min, "must be less than or equal to #{length_max} (Length max)") if length_min.to_i > length_max.to_i
  end

  def gist_lte_length_max
    return if gist.blank?
    str = constraints['length_max']
    self.length_max = str.blank? ? CHARACTER_VARYING_255 : str.to_i
    errors.add(:gist, "length must be less than #{length_max + 1}") if gist.length > length_max
  end

  def gist_gte_length_min
    return if gist.blank?
    str = constraints['length_min']
    self.length_min = str.blank? ? 1 : str.to_i
    errors.add(:gist, "length must be greater than #{length_min - 1}") if gist.length < length_min
  end
end
