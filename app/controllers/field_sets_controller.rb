class FieldSetsController < ApplicationController

  before_action :field_set_assign, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @field_sets = FieldSet.by_name
  end

  def show
    @custom_fields = @field_set.custom_fields.ranked_page(params[:page])
    paginate_row_offset_assign
  end

  def new
    @field_set = FieldSet.subklass(params[:kind])
    redirect_to(root_path, alert: "Quantity limit reached for #{@field_set.type_human true}s") unless @field_set.new_able?
  end

  def edit
  end

  def create
    @field_set = FieldSet.subklass_with(params_white)
    redirect_to(root_path, alert: "Quantity limit reached for #{@field_set.type_human true}s") and return unless @field_set.class.new_able?
    if @field_set.save
      redirect_to field_sets_path, notice: t('controllers.flash.create.success', entity: @field_set.type_human)
    else
      flash[:alert] = t('controllers.flash.create.failure', entity: @field_set.type_human(true))
      render :new
    end
  end

  def update
    if @field_set.update(params_white)
      redirect_to field_sets_path, notice: t('controllers.flash.update.success', entity: @field_set.type_human)
    else
      flash[:alert] = t('controllers.flash.update.failure', entity: @field_set.type_human(true))
      render :edit
    end
  end

  def destroy
    redirect_to root_path and return unless @field_set.destroyable?
    @field_set.destroy
    redirect_to field_sets_path, notice: t('controllers.flash.destroy.success', entity: @field_set.type_human)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:id])
  end

  def params_white
    params.require(:field_set).permit(
      :description,
      :name,
      :type)
  end
end
