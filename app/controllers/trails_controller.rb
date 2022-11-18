class TrailsController < ApplicationController
  before_action :set_trail, only: [:show, :edit, :update, :destroy]

  def index
    @trails = Trail.all
  end

  def show
    @ongoing_practice = @trail.practices.where(status: :STARTED)
    @past_practice = @trail.practices.where(status: :FINISHED)
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

    redirect_to root_path, status: :see_other
  end

  private
  def set_trail
    @trail = Trail.find(params[:id])
  end

  def trail_params
    params.require(:trail).permit(:name)
  end
end
