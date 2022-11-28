class PracticesController < ApplicationController
  before_action :set_person, only: %i[create update]

  def new
    @person = Person.find(params[:person_id])
    @trails = Trail.all
    @practice = Practice.new
  end

  def create
    @trails = Trail.all
    @practice = @person.practices.create(practice_params)

    redirect_to person_path(@person) and return if @practice.errors.blank?

    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    @practice = Practice.find(params[:id])

    redirect_to person_path(@person) and return if @practice.update(practice_params)

    render :edit, status: :unprocessable_entity
  end

  private

  def set_person
    @person = Person.find(practice_params[:person_id])
  end

  def practice_params
    params.require(:practice).permit(:person_id, :trail_id, :status)
  end
end
