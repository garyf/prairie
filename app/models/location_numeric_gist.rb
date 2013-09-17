class LocationNumericGist < NumericGist

  belongs_to :location, foreign_key: :parent_id

end
