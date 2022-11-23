class RacesController < ApplicationController
  prepend_before_action :set_trail
  before_action :set_race, except: %i[index new create]

  def index
    @races = @trail.races
  end

  def show
  end

  def new
    @race = Race.new
  end

  def create
    # TODO: validation
    redirect_to trail_races_path(@trail) and return if @trail.races.create!(race_params)

    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    # TODO: dont update an ongoing race
    redirect_to trail_race_path(@race) and return if @race.update(race_params)

    render :edit, status: :unprocessable_entity
  end

  def destroy
    @race.destroy
    redirect_to trail_races_path(@trail), status: :see_other
  end

  private

  def set_trail
    @trail = Trail.find(params[:trail_id])
  end

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:name, :duration, :start)
  end
end
