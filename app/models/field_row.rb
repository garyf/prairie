class FieldRow < ActiveRecord::Base
  belongs_to :custom_field
  belongs_to :field_set
end
