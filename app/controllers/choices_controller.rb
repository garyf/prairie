class ChoicesController < ApplicationController

  before_action :choice_field_assign, :new_allow?, only: [:new, :create]
  before_action :choice_assign, :from_assn_choice_field_assign, :edit_allow?, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @choice = @choice_field.choices.new
  end

  def edit
    edit_assigns
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
      edit_assigns
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

  def new_allow?
    redirect_to root_path and return unless @choice_field.choice_new_able?
  end

  def choice_assign
    @choice = Choice.find(params[:id])
  end

  def from_assn_choice_field_assign
    @choice_field = @choice.custom_field
  end

  def edit_allow?
    redirect_to root_path and return unless @choice_field.edit_able?
  end

  def edit_assigns
    @row_edit_able_p = @choice_field.choice_row_edit_able?
    @choice.row_position = @choice.human_row if @row_edit_able_p
    @parent_p = @choice_field.parent?
  end

  def params_white
    params.require(:choice).permit(
      :custom_field_id,
      :name,
      :row_position)
  end
end
