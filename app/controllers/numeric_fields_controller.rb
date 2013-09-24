class NumericFieldsController < TextFieldsController

  before_action :numeric_field_assign, :field_set_assign, :parent_assign
  respond_to :html

  def edit
    @numeric_field = @numeric_field.gist_fetch(@parent)
  end

  def update
    gist_store_or_edit
  end

private

  def numeric_field_assign
    @text_field = @numeric_field = NumericField.find(params[:id])
  end

  def parent_assign
    @parent = @numeric_field.parent(params[:parent_id] || params[:numeric_field][:parent_id])
  end

  def params_white
    params.require(:numeric_field).permit(
      :gist,
      :parent_id)
  end
end
