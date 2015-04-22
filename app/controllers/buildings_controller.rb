class BuildingsController < ApplicationController
  attr_reader :start_time

  before_action :set_building, only: [:show, :edit, :update, :destroy]

  # GET /buildings
  # GET /buildings.json
  def index
    @buildings = Building.all
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
  end

  def run
  end

  def demolished_building
    building_name = Building.first.name
    if session[:building_name] == building_name
      redirect_to run_path, notice: 'You still have time!'
    end
  end

  # GET /buildings/new
  def new
    @building = Building.new
  end

  # GET /buildings/1/edit
  def edit
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(building_params)
    respond_to do |format|
      if @building.save
        format.html { redirect_to @building, notice: 'Building was successfully created.' }
        format.json { render :show, status: :created, location: @building }
      else
        format.html { render :new }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buildings/1
  # PATCH/PUT /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        format.html { redirect_to @buidling, notice: 'Building was successfully updated.' }
        format.json { render :show, status: :ok, location: @building }
      else
        format.html { render :edit }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    session[:building_name] = @building.name
    #@building.destroy
    #DestroyBuildingJob.perform_async(@building, 10)
    #Building.destroy_building(@building)
    DestroyBuildingJob.set(wait: 10.seconds).perform_later(@building)
    respond_to do |format|
      format.html { redirect_to run_path, notice: 'Oh No! You activated demolition, you have at least 10 seconds to leave the building. ' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id] || Building.first.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_params
      params.require(:building).permit(:name)
    end

  # def create_twin(building)
  #   Building.create!(name: building.name)
  # end
end
