class SetupStringFieldsController < ApplicationController

  before_action :field_set_assign, only: [:new, :create]
  before_action :string_field_assign, :from_assn_field_set_assign, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @string_field = StringField.new
  end

  def edit
    @string_field = @string_field.constraints_fetch
  end

  def create
    @string_field = @field_set.string_fields.new(params_white)
    if @string_field.save
      @string_field.constraints_store(params_white, @field_set.id)
      redirect_to field_set_path(@field_set), notice: 'String field successfully created'
    else
      flash[:alert] = 'Failed to create string field'
      render :new
    end
  end

  def update
    if @string_field.update(params_white)
      @string_field.constraints_store(params_white)
      redirect_to field_set_path(@field_set), notice: 'String field successfully updated'
    else
      @string_field = @string_field.constraints_fetch
      flash[:alert] = 'Failed to update string field'
      render :edit
    end
  end

  def destroy
    @string_field.destroy
    flash[:notice] = 'String field successfully destroyed'
    redirect_to field_set_path(@field_set)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:field_set_id])
  end

  def string_field_assign
    @string_field = StringField.find(params[:id])
  end

  def from_assn_field_set_assign
    @field_set = @string_field.field_set
  end

  def params_white
    params.require(:string_field).permit(
      :length_max,
      :length_min,
      :name)
  end
end
