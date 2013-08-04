class SetupChoiceFieldsController < ApplicationController

  before_action :field_set_assign, only: [:new, :create]
  before_action :choice_field_assign, :from_assn_field_set_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def show
    @choices = @choice_field.choices.ranked_page(params[:page])
    paginate_row_offset_assign
  end

  def new
    @choice_field = ChoiceField.subklass(params[:kind], @field_set.id)
  end

  def edit
    edit_assigns
  end

  def create
    @choice_field = ChoiceField.subklass_with(params_white)
    if @choice_field.save
      redirect_to setup_choice_field_path(@choice_field), notice: 'Choice field successfully created'
    else
      flash[:alert] = 'Failed to create choice field'
      render :new
    end
  end

  def update
    if @choice_field.update(params_white_w_human_row)
      redirect_to field_set_path(@field_set), notice: 'Choice field successfully updated'
    else
      edit_assigns
      flash[:alert] = 'Failed to update choice field'
      render :edit
    end
  end

  def destroy
    @choice_field.garbage_collect_and_self_destroy
    flash[:notice] = 'Choice field successfully destroyed'
    redirect_to field_set_path(@field_set)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:field_set_id] || params[:choice_field][:field_set_id])
  end

  def choice_field_assign
    @choice_field = CustomField.find(params[:id])
  end

  def from_assn_field_set_assign
    @field_set = @choice_field.field_set
  end

  def edit_assigns
    @row_edit_able_p = @field_set.custom_field_row_edit_able?
    @choice_field.row_position = @choice_field.human_row if @row_edit_able_p
  end

  def params_white
    params.require(:choice_field).permit(
      :field_set_id,
      :name,
      :row_position,
      :type)
  end
end
