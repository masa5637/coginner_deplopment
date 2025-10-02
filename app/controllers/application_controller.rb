class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # サインアップ時に name と display_name を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :display_name])
    
    # アカウント更新時に name と display_name を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :display_name])
  end

  # ログイン後に必ずプロフィールページにリダイレクト
  def after_sign_in_path_for(resource)
    profile_path
  end
end
