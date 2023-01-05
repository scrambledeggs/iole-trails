class PracticesController < ApplicationController
  before_action :set_person

  def new
    @practice = Practice.new
  end

  def create
    @practice = @person.practices.create(practice_params)

    redirect_to person_path(@person) and return if @practice.errors.blank?

    render :new, status: :unprocessable_entity
  end

  def update
    @practice = Practice.find(params[:id])

    @practice.update(practice_params)
    redirect_to person_path(@person)

    # TODO: case when update fails
  end

  private

  def set_person
    @person = Person.find(params[:person_id] || practice_params[:person_id])
  end

  def practice_params
    params.require(:practice).permit(:person_id, :trail_id, :status)
  end
end
