class PersonNumericGist < NumericGist

  belongs_to :person, foreign_key: :parent_id

end
