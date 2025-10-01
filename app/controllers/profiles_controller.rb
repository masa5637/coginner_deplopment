class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @works = @user.works.order(created_at: :desc)
    @liked_works = @user.likes.includes(:work).map(&:work).compact
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "プロフィールを更新しました"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:display_name, :avatar, :bio)
  end
end

