class PracticesController < ApplicationController
  before_action :set_person, only: [:new, :finish]

  def new
    @trails = Trail.all
    @practice = Practice.new
  end

  def create
    @person = Person.find(practice_params[:person_id])
    @trail = Trail.find(practice_params[:trail_id])

    if @trail.eligible?(@person.age, @person.weight, @person.body_build) && !@person.has_ongoing_practice?
      if @person.practices.create!(practice_params)
        redirect_to person_path(@person)
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_practice_path(person_id: practice_params[:person_id]), status: :precondition_failed 
    end
  end

  def edit
  end

  def update
    @practice = Practice.find(params[:id])
    @person = Person.find(params[:practice][:person_id])
    if @practice.update(practice_params)
      redirect_to person_path(@person)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_person
    @person = Person.find(params[:person_id])
  end

  def practice_params
    params.require(:practice).permit(:person_id, :trail_id, :status)
  end
end
