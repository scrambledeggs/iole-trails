class RunController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

  def set_person
    @person = Person.find(run_params[:person_id])
  end

  def run_params
    params.require(:run).permit(:person_id, :race_id, :status)
  end
end
