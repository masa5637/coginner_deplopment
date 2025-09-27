class WorksController < ApplicationController
  def index
    @q = Work.ransack(params[:q])
    @works = @q.result.includes(:user, :tags).distinct
  end

  def show
    @work = Work.find(params[:id])
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)
    if @work.save
      redirect_to works_path
    else
      render :new
    end
  end

  private

  def work_params
    params.require(:work).permit(:title, :description, :image_url, tag_ids: [])
  end
end