# app/controllers/profiles_controller.rb
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
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # display_name, avatar, bio を許可
    params.require(:user).permit(:display_name, :avatar, :bio)
  end
end