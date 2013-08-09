class SetupNumericFieldsController < ApplicationController

  before_action :field_set_assign, :new_allow?, only: [:new, :create]
  before_action :numeric_field_assign, :from_assn_field_set_assign, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @numeric_field = @field_set.numeric_fields.new
  end

  def edit
    edit_assigns
  end

  def create
    @numeric_field = @field_set.numeric_fields.new(params_white)
    if @numeric_field.save
      @numeric_field.constraints_store(params_white)
      redirect_to field_set_path(@field_set), notice: 'Numeric field successfully created'
    else
      flash[:alert] = 'Failed to create numeric field'
      render :new
    end
  end

  def update
    if @numeric_field.update(params_white_w_human_row)
      @numeric_field.constraints_store(params_white)
      redirect_to field_set_path(@field_set), notice: 'Numeric field successfully updated'
    else
      edit_assigns
      flash[:alert] = 'Failed to update numeric field'
      render :edit
    end
  end

  def destroy
    @numeric_field.garbage_collect_and_self_destroy
    flash[:notice] = 'Numeric field successfully destroyed'
    redirect_to field_set_path(@field_set)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:field_set_id] || params[:numeric_field][:field_set_id])
  end

  def new_allow?
    redirect_to root_path and return unless @field_set.custom_field_new_able?
  end

  def numeric_field_assign
    @numeric_field = NumericField.find(params[:id])
  end

  def from_assn_field_set_assign
    @field_set = @numeric_field.field_set
  end

  def edit_assigns
    @numeric_field = @numeric_field.constraints_fetch
    @row_edit_able_p = @field_set.custom_field_row_edit_able?
    @numeric_field.row_position = @numeric_field.human_row if @row_edit_able_p
    @parent_p = @numeric_field.parent?
  end

  def params_white
    params.require(:numeric_field).permit(
      :field_set_id,
      :name,
      :only_integer_p,
      :row_position,
      :value_max,
      :value_min)
  end
end
