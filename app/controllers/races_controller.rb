class RacesController < ApplicationController
  prepend_before_action :set_trail, except: %i[all]
  before_action :set_race, except: %i[index new create all]

  def index
    @races = @trail.races
  end

  def show
    return if !@race.winner.present?

    @winning_run = Run.find(@race.winner)
    @winner = @winning_run.person
  end

  def new
    @race = Race.new
  end

  def create
    @race = @trail.races.create(race_params)

    redirect_to trail_race_path(@trail, @race) and return if @race.errors.blank?

    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    redirect_to trail_race_path(@trail, @race) and return if @race.update(race_params)

    render :edit, status: :unprocessable_entity and return if !@race.errors.include?(:status)

    flash[:alert] = @race.errors.messages_for(:status).first
    redirect_to trail_race_path(@trail, @race)
  end

  def destroy
    @race.destroy
    redirect_to trail_races_path(@trail), status: :see_other
  end

  def all
    @races = Race.all.order(:start)
  end

  def finish
    update_race_response = RaceUpdater.call(@race, :FINISHED, true)

    redirect_to trail_race_path(@trail, @race) and return if update_race_response[:result]

    flash[:alert] = update_race_response[:message]
    redirect_to trail_race_path(@trail, @race)
  end

  private

  def set_trail
    @trail = Trail.find(params[:trail_id])
  end

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:name, :duration, :start, :status)
  end
end
