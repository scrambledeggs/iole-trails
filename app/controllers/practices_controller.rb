class PracticesController < ApplicationController
  before_action :set_person, only: [:create, :update]

  def new
    @person = Person.find(params[:person_id])
    @trails = Trail.all
    @practice = Practice.new
  end

  def create
    @trail = Trail.find(practice_params[:trail_id])

    if @person.practice_on?(@trail)
      if @person.practices.create!(practice_params)
        redirect_to person_path(@person)
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash[:alert] = "Not eligible in #{@trail.name} Trail. Select a different trail."
      redirect_to new_practice_path(person_id: practice_params[:person_id]), status: :precondition_failed
    end
  end

  def edit
  end

  def update
    @practice = Practice.find(params[:id])
    if @practice.update(practice_params)
      redirect_to person_path(@person)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_person
    @person = Person.find(practice_params[:person_id])
  end

  def practice_params
    params.require(:practice).permit(:person_id, :trail_id, :status)
  end
end
