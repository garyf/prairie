class SetupStringFieldsController < SetupTextFieldsController

  before_action :field_set_assign, :new_allow?, only: [:new, :create]
  before_action :string_field_assign, :from_assn_field_set_assign, only: [:edit, :update, :destroy]
  respond_to :html

  def new
    @string_field = @field_set.string_field_new
  end

  def edit
    edit_assigns
  end

  def create
    @text_field = @string_field = @field_set.string_field_new(params_white)
    constraints_store_or_new
  end

  def update
    constraints_store_or_edit
  end

  def destroy
    @string_field.garbage_collect_and_self_destroy
    flash[:notice] = 'String field successfully destroyed'
    redirect_to field_set_path(@field_set)
  end

private

  def field_set_assign
    @field_set = FieldSet.find(params[:field_set_id] || params[:string_field][:field_set_id])
  end

  def new_allow?
    redirect_to root_path and return unless @field_set.custom_field_new_able?
  end

  def string_field_assign
    @text_field = @string_field = StringField.find(params[:id])
  end

  def from_assn_field_set_assign
    @field_set = @string_field.field_set
  end

  def edit_assigns
    @string_field = @string_field.constraints_fetch
    @row_edit_able_p = @field_set.custom_field_row_edit_able?
    @string_field.row_position = @string_field.human_row if @row_edit_able_p
    @parent_p = @string_field.parent?
  end

  def params_white
    params.require(:string_field).permit(
      :enabled_p,
      :field_set_id,
      :length_max,
      :length_min,
      :name,
      :required_p,
      :row_position)
  end
end
