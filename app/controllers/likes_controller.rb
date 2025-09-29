class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work

  def create
    @work.likes.create(user: current_user)
    redirect_back fallback_location: work_path(@work)
  end

  def destroy
    like = @work.likes.find_by(user: current_user)
    like&.destroy
    redirect_back fallback_location: work_path(@work)
  end

  private

  def set_work
    @work = Work.find(params[:work_id])
  end
end
