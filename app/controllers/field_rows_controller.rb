class FieldRowsController < ApplicationController

  before_action :field_row_assign, :custom_field_assign, :field_set_assign
  respond_to :html

  def edit
  end

  def update
    if @field_row.update(params_white_w_human_row)
      redirect_to field_set_path(@field_set), notice: 'Field row successfully updated'
    else
      flash[:alert] = 'Failed to update field row'
      render :edit
    end
  end

private

  def field_row_assign
    @field_row = FieldRow.find(params[:id])
  end

  def custom_field_assign
    @custom_field = @field_row.custom_field
  end

  def field_set_assign
    @field_set = @field_row.field_set
  end

  def params_white
    params.require(:field_row).permit(:row_position)
  end
end
