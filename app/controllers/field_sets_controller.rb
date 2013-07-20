class FieldSetsController < ApplicationController
  before_action :set_field_set, only: [:show, :edit, :update, :destroy]

  # GET /field_sets
  # GET /field_sets.json
  def index
    @field_sets = FieldSet.all
  end

  # GET /field_sets/1
  # GET /field_sets/1.json
  def show
  end

  # GET /field_sets/new
  def new
    @field_set = FieldSet.new
  end

  # GET /field_sets/1/edit
  def edit
  end

  # POST /field_sets
  # POST /field_sets.json
  def create
    @field_set = FieldSet.new(field_set_params)

    respond_to do |format|
      if @field_set.save
        format.html { redirect_to @field_set, notice: 'Field set was successfully created.' }
        format.json { render action: 'show', status: :created, location: @field_set }
      else
        format.html { render action: 'new' }
        format.json { render json: @field_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_sets/1
  # PATCH/PUT /field_sets/1.json
  def update
    respond_to do |format|
      if @field_set.update(field_set_params)
        format.html { redirect_to @field_set, notice: 'Field set was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @field_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_sets/1
  # DELETE /field_sets/1.json
  def destroy
    @field_set.destroy
    respond_to do |format|
      format.html { redirect_to field_sets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_set
      @field_set = FieldSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_set_params
      params.require(:field_set).permit(:type, :name, :description)
    end
end
