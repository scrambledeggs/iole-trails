class RaceController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_trail
    @trail = Trail.find(race_params[:trail_id])
  end

  def race_params
    params.require(:race).permit(:name)
  end
end
