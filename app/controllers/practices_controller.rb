class PracticesController < ApplicationController
  prepend_before_action :set_person, only: [:new, :create]
  before_action :check_eligibility, only: [:create]

  def new
    @trails = Trail.all
  end

  def create
    @practice = @person.practices.create!(practice_params)
    redirect_to person_path(@person)
  end

  private
  def set_person
    @person = Person.find(params[:person_id])
  end

  def check_eligibility
    @trail = Trail.find(params[:practice][:trail_id])
    throw(:abort) if !@trail.eligible?(@person.age, @person.weight, @person.body_build) || @person.has_ongoing_trail?
  end

  def practice_params
    params.require(:practice).permit(:trail_id)
  end
end
