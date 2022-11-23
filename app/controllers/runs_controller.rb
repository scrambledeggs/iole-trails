class RunsController < ApplicationController
  before_action :set_person, only: %i[create update]

  def new
    @run = Run.new
  end

  def create
    # validation
    redirect_to person_path(@person) and return if @person.runs.create!(run_params)

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
