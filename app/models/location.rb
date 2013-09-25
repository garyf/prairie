class Location < ActiveRecord::Base

  extend Nearby
  extend ParentQuery
  include Redis::Objects
  include RedisFieldValues

  has_many :location_numeric_gists, foreign_key: :parent_id, dependent: :destroy
  has_many :location_string_gists, foreign_key: :parent_id, dependent: :destroy

  paginates_per 8

  validates :description, length: {maximum: 255}
  validates :elevation_feet, numericality: {greater_than: -1, less_than: 30000, only_integer: true}, allow_blank: true
  validates :lot_acres, numericality: {greater_than: 0, less_than: 9999999}, allow_blank: true
  validates :name, presence: true, length: {maximum: 55}
  validates :public_p, inclusion: {in: [true, false], message: 'must be true or false'}

  def self.by_name(page)
    order('name').page page
  end

  def self.id_where_ILIKE_value(column, value)
    where(Location.arel_table[column].matches "%#{value}%").pluck(:id)
  end

  def self.name_where_ids_preserve_order(ids)
    column_where_ids_preserve_order(:name, ids)
  end

  def self.search_results_fetch(search_cache, page)
    name_where_ids_preserve_order(search_cache.result_ids_fetch page)
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
