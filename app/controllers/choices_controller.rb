class ChoicesController < ApplicationController

  before_action :choice_field_assign, only: [:new, :create]
  before_action :choice_assign, :from_assn_choice_field_assign, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @choice = @choice_field.choices.new
  end

  def edit
    @choice.row_position = @choice.human_row
  end

  def create
    @choice = @choice_field.choices.new(params_white)
    if @choice.save
      redirect_to setup_choice_field_path(@choice_field), notice: 'Choice successfully created'
    else
      flash[:alert] = 'Failed to create choice'
      render :new
    end
  end

  def update
    if @choice.update(params_white_w_human_row)
      redirect_to setup_choice_field_path(@choice_field), notice: 'Choice successfully updated'
    else
      flash[:alert] = 'Failed to update choice'
      render :edit
    end
  end

  def destroy
    @choice.destroy
    redirect_to setup_choice_field_path(@choice_field), notice: 'Choice successfully destroyed'
  end

private

  def choice_field_assign
    @choice_field = CustomField.find(params[:custom_field_id] || params[:choice][:custom_field_id])
  end

  def choice_assign
    @choice = Choice.find(params[:id])
  end

  def from_assn_choice_field_assign
    @choice_field = @choice.custom_field
  end

  def params_white
    params.require(:choice).permit(
      :custom_field_id,
      :name,
      :row_position)
  end
end
