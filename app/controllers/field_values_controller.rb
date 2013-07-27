class FieldValuesController < ApplicationController

  respond_to :html

  def index
    @field_set = FieldSet.find(params[:field_set_id])
    @custom_fields = @field_set.custom_fields.ranked_page(params[:page])
    @parent = @field_set.parent(params[:parent_id])
    @field_values = @parent.field_values
  end
end
