class FieldRowsController < ApplicationController
  before_action :set_field_row, only: [:show, :edit, :update, :destroy]

  # GET /field_rows
  # GET /field_rows.json
  def index
    @field_rows = FieldRow.all
  end

  # GET /field_rows/1
  # GET /field_rows/1.json
  def show
  end

  # GET /field_rows/new
  def new
    @field_row = FieldRow.new
  end

  # GET /field_rows/1/edit
  def edit
  end

  # POST /field_rows
  # POST /field_rows.json
  def create
    @field_row = FieldRow.new(field_row_params)

    respond_to do |format|
      if @field_row.save
        format.html { redirect_to @field_row, notice: 'Field row was successfully created.' }
        format.json { render action: 'show', status: :created, location: @field_row }
      else
        format.html { render action: 'new' }
        format.json { render json: @field_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_rows/1
  # PATCH/PUT /field_rows/1.json
  def update
    respond_to do |format|
      if @field_row.update(field_row_params)
        format.html { redirect_to @field_row, notice: 'Field row was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @field_row.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_rows/1
  # DELETE /field_rows/1.json
  def destroy
    @field_row.destroy
    respond_to do |format|
      format.html { redirect_to field_rows_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_row
      @field_row = FieldRow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_row_params
      params.require(:field_row).permit(:custom_field_id, :field_set_id, :row)
    end
end
