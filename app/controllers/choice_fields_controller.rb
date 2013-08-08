class ChoiceFieldsController < ApplicationController

  before_action :choice_field_assign, :field_set_assign, :parent_assign
  respond_to :html

  def edit
    @choice_field = @choice_field.gist_fetch(@parent)
    choices_assign
  end

  def update
    if @choice_field.gist_store(@parent, params_white)
      redirect_to(field_values_path(field_set_id: @field_set.id, parent_id: @parent.id),
        notice: t('controllers.flash.update.success', entity: @choice_field.type_human))
    else
      choices_assign
      flash[:alert] = t('controllers.flash.update.failure', entity: @choice_field.type_human(true))
      render :edit
    end
  end

private

  def choice_field_assign
    @choice_field = ChoiceField.find(params[:id])
  end

  def field_set_assign
    @field_set = @choice_field.field_set
  end

  def parent_assign
    @parent = @choice_field.parent(params[:parent_id] || params[:choice_field][:parent_id])
  end

  def choices_assign
    @choices = @choice_field.choices.name_by_row
  end

  def params_white
    params.require(:choice_field).permit(
      :gist,
      :parent_id)
  end
end
