class NumericFieldsController < ApplicationController

  before_action :numeric_field_assign, :field_set_assign, :parent_assign
  respond_to :html

  def edit
    @numeric_field = @numeric_field.gist_fetch(@parent)
  end

  def update
    if @numeric_field.gist_store(@parent, params_white)
      redirect_to(field_values_path(field_set_id: @field_set.id, parent_id: @parent.id),
        notice: 'Numeric field successfully updated')
    else
      @numeric_field.parent_id = @parent.id
      flash[:alert] = 'Failed to update numeric field'
      render :edit
    end
  end

private

  def numeric_field_assign
    @numeric_field = NumericField.find(params[:id])
  end

  def field_set_assign
    @field_set = @numeric_field.field_set
  end

  def parent_assign
    @parent = @numeric_field.parent(params[:parent_id] || params[:numeric_field][:parent_id])
  end

  def params_white
    params.require(:numeric_field).permit(
      :gist,
      :parent_id)
  end
end
