class FieldValuesController < ApplicationController

  respond_to :html

  def index
    @field_set = FieldSet.find(params[:field_set_id])
    @custom_fields = @field_set.custom_fields.enabled_by_row_page(params[:page])
    @required_any_p = @field_set.custom_fields.required_any?
    @parent = @field_set.parent(params[:parent_id])
    @field_values = @parent.field_values
  end
end
