class PracticesController < ApplicationController
  prepend_before_action :set_person, only: [:new, :finish]
  before_action :check_eligibility, only: [:create]

  def new
    @trails = Trail.all
    @practice = Practice.new
  end

  def create
    if @person.practices.create!(practice_params)
      redirect_to person_path(@person)
    else
      render :new, status: :unprocessable_entity
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

  def check_eligibility
    @person = Person.find(params[:practice][:person_id])
    @trail = Trail.find(params[:practice][:trail_id])
    throw(:abort) if !@trail.eligible?(@person.age, @person.weight, @person.body_build) || @person.has_ongoing_trail?
  end

  def practice_params
    params.require(:practice).permit(:person_id, :trail_id, :status)
  end
end
