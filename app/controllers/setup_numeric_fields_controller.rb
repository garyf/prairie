class SetupNumericFieldsController < ApplicationController

  before_action :field_set_assign, only: [:new, :create]
  before_action :numeric_field_assign, :from_assn_field_set_assign, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @numeric_field = NumericField.new
  end

  def edit
    @numeric_field = @numeric_field.constraints_fetch
    @parent_p = @numeric_field.parent?
  end

  def create
    @numeric_field = @field_set.numeric_fields.new(params_white)
    if @numeric_field.save
      @numeric_field.constraints_store(params_white, @field_set.id)
      redirect_to field_set_path(@field_set), notice: 'Numeric field successfully created'
    else
      flash[:alert] = 'Failed to create numeric field'
      render :new
    end
  end

  def update
    if @numeric_field.update(params_white)
      @numeric_field.constraints_store(params_white)
      redirect_to field_set_path(@field_set), notice: 'Numeric field successfully updated'
    else
      @numeric_field = @numeric_field.constraints_fetch
      @parent_p = @numeric_field.parent?
      flash[:alert] = 'Failed to update numeric field'
      render :edit
    end
  end

  def destroy
    @numeric_field.parents_garbage_collect_and_self_destroy
    flash[:notice] = 'Numeric field successfully destroyed'
    redirect_to field_set_path(@field_set)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:field_set_id])
  end

  def numeric_field_assign
    @numeric_field = NumericField.find(params[:id])
  end

  def from_assn_field_set_assign
    @field_set = @numeric_field.field_set
  end

  def params_white
    params.require(:numeric_field).permit(
      :name,
      :only_integer_p,
      :value_max,
      :value_min)
  end
end
