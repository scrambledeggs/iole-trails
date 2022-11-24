class RunsController < ApplicationController
  before_action :set_person, only: %i[create update]

  def new
    @run = Run.new
    @person = Person.find(params[:person_id])
    @races = Race.all
  end

  def create
    @run = @person.runs.create(run_params)
    @races = Race.all

    redirect_to person_path(@person) and return if @run.errors.blank?

    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    @run = Run.find(params[:id])

    redirect_to person_path(@person) and return if @person.runs.update!(run_params)

    render :edit, status: :unprocessable_entity
  end

  private

  def set_person
    @person = Person.find(run_params[:person_id])
  end

  def run_params
    params.require(:run).permit(:person_id, :race_id, :status)
  end
end
