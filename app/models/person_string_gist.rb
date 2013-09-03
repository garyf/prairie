class PersonStringGist < StringGist

  belongs_to :person, foreign_key: :parent_id

end
