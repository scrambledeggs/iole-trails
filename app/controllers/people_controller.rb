class PeopleController < ApplicationController
  before_action :set_person, except: [:index, :new, :create]

  def index
    @people = Person.all
  end

  def show
    @ongoing_practice = @person.practices.where(status: :STARTED)
    @past_practice = @person.practices.where(status: :FINISHED)
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to @person
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy

    redirect_to root_path, status: :see_other
  end

private
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :age, :weight, :body_build)
  end
end
