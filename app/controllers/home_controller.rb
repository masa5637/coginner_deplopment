class HomeController < ApplicationController
  def index
    @q = Work.ransack(params[:q])

    if params[:q].present?
      # 検索条件がある場合
      @works = @q.result(distinct: true).includes(:user, :tags)
    else
      # 検索条件なしで全作品を取得
      @works = Work.includes(:user, :tags).all
    end
  end
end
