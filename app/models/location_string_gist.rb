class LocationStringGist < StringGist

  belongs_to :location, foreign_key: :parent_id

end
