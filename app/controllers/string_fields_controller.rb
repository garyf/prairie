class StringFieldsController < TextFieldsController

  before_action :string_field_assign, :field_set_assign, :parent_assign
  respond_to :html

  def edit
    @string_field = @string_field.gist_fetch(@parent)
  end

  def update
    gist_store_or_edit
  end

private

  def string_field_assign
    @text_field = @string_field = StringField.find(params[:id])
  end

  def parent_assign
    @parent = @string_field.parent(params[:parent_id] || params[:string_field][:parent_id])
  end

  def params_white
    params.require(:string_field).permit(
      :gist,
      :parent_id)
  end
end
