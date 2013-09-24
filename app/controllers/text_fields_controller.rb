class TextFieldsController < ApplicationController

  respond_to :html

  def gist_store_or_edit
    if @text_field.gist_store(@parent, params_white)
      redirect_to(field_values_path(field_set_id: @field_set.id, parent_id: @parent.id),
        notice: t('controllers.flash.update.success', entity: @text_field.type_human))
    else
      @text_field.parent_id = @parent.id
      flash[:alert] = t('controllers.flash.update.failure', entity: @text_field.type_human(true))
      render :edit
    end
  end

private

  def field_set_assign
    @field_set = @text_field.field_set
  end
end
