class SetupTextFieldsController < ApplicationController

  respond_to :html

  def constraints_store_or_new
    if @text_field.save
      @text_field.constraints_store(params_white)
      redirect_to field_set_path(@field_set), notice: t('controllers.flash.create.success', entity: @text_field.type_human)
    else
      flash[:alert] = t('controllers.flash.create.failure', entity: @text_field.type_human(true))
      render :new
    end
  end
end
