class Location < ActiveRecord::Base

  include Redis::Objects
  include RedisFieldValues

  has_many :location_numeric_gists, foreign_key: :parent_id, dependent: :destroy
  has_many :location_string_gists, foreign_key: :parent_id, dependent: :destroy

  paginates_per 8

  validates :name, presence: true

  def self.by_name(page)
    order('name').page page
  end

  def self.id_where_case_insensitive_value(column, value)
    where("lower(#{column}) = ?", value.downcase).pluck(:id)
  end

  def self.id_where_ILIKE_value(column, value)
    where(Location.arel_table[column].matches "%#{value}%").pluck(:id)
  end

  def self.id_where_id(ids)
    select(:id).where(id: ids)
  end

  def self.name_where_ids_preserve_order(ids)
    hsh = select(:id, :name).where(id: ids).group_by(&:id)
    ids.map { |k| hsh[k.to_i].first }
  end

  def numeric_gist_cr(custom_field_id, gist)
    LocationNumericGist.create(
      custom_field_id: custom_field_id,
      gist: gist.downcase,
      parent_id: id)
  end

  def string_gist_cr(custom_field_id, gist)
    LocationStringGist.create(
      custom_field_id: custom_field_id,
      gist: gist.downcase,
      parent_id: id)
  end
end
