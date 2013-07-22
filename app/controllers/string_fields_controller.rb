class StringFieldsController < ApplicationController

  before_action :string_field_assign, :field_set_assign, :parent_assign
  respond_to :html

  def edit
    @string_field = @string_field.gist_fetch(@parent)
  end

  def update
    if @string_field.gist_store(@parent, params_white)
      redirect_to(field_values_path(field_set_id: @field_set.id, parent_id: @parent.id),
        notice: 'String field successfully updated')
    else
      @string_field.parent_id = @parent.id
      flash[:alert] = 'Failed to update string field'
      render :edit
    end
  end

private

  def string_field_assign
    @string_field = StringField.find(params[:id])
  end

  def field_set_assign
    @field_set = @string_field.field_set
  end

  def parent_assign
    @parent = @string_field.parent(params[:parent_id] || params[:string_field][:parent_id])
  end

  def params_white
    params.require(:string_field).permit(
      :gist,
      :parent_id)
  end
end
