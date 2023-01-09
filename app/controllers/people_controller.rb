class PeopleController < ApplicationController
  before_action :set_person, except: %i[index new create]

  def index
    @people = Person.all
  end

  def show
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    redirect_to @person and return if @person.save

    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    redirect_to @person and return if @person.update(person_params)

    render :edit, status: :unprocessable_entity
  end

  def destroy
    @person.destroy
    redirect_to people_path, status: :see_other
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :birthdate, :weight, :body_build)
  end
end
