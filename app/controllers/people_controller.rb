class PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def show
  end
end
