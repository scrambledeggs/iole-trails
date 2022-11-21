class TrailsController < ApplicationController
  before_action :set_trail, only: [:show, :edit, :update, :destroy, :eligibles]

  def index
    @trails = Trail.all
  end

  def show
  end

  def new
    @trail = Trail.new
  end

  def create
    @trail = Trail.new(trail_params)

    if @trail.save
      redirect_to @trail
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @trail.update(trail_params)
      redirect_to @trail
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trail.destroy

    redirect_to trails_path, status: :see_other
  end

  def eligibles
  end

  private

  def set_trail
    @trail = Trail.find(params[:id])
  end

  def trail_params
    params.require(:trail).permit(:name, :age_minimum, :age_maximum, :body_build, :weight_minimum, :weight_maximum)
  end
end
