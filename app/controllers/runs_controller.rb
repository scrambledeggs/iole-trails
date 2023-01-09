class RunsController < ApplicationController
  before_action :set_person
  before_action :set_run, only: %i[show update]
  before_action :set_races, only: %i[new create]

  def show
  end

  def new
    @run = Run.new
  end

  def create
    @run = @person.runs.create(run_params)

    redirect_to person_path(@person) and return if @run.errors.blank?

    render :new, status: :unprocessable_entity
  end

  def update
    @run.update!(run_params)

    redirect_to person_run_path(@person, @run)

    # TODO: case when update fails
  end

  private

  def set_person
    @person = Person.find(params[:person_id] || run_params[:person_id])
  end

  def set_run
    @run = Run.find(params[:id])
  end

  def set_races
    @races = Race.where(status: :NEW)
  end

  def run_params
    params.require(:run).permit(:person_id, :race_id, :status)
  end
end
