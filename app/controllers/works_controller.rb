class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index
    @q = Work.ransack(params[:q])
    
    # この1行を追加するだけ
    @has_search_query = params[:q].present? && params[:q].values.any?(&:present?)

    if params[:q].present?
      @works = @q.result(distinct: true).includes(:user, :tags)
    else
      @works = Work.includes(:user, :tags).all
    end
  end

  # 以下は全て変更なし
  def show
    @show_share_button = true
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params.except(:images))
    @work.user = current_user

    if work_params[:images]
      work_params[:images].each do |image|
        @work.images.attach(image)
      end
    end

    if @work.save
      redirect_to works_path, notice: "作品を投稿しました"
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @work.update(work_params.except(:images))
      if work_params[:images]
        work_params[:images].each do |image|
          @work.images.attach(image)
        end
      end
      redirect_to work_path(@work), notice: "作品を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def destroy
    @work.destroy
    redirect_to works_path, notice: "投稿を削除しました"
  end

  private

  def set_work
    @work = Work.find(params[:id])
  end

  def work_params
    permitted = params.require(:work).permit(:title, :description, images: [], tag_ids: [])

    if permitted[:images]
      permitted[:images].reject!(&:blank?)
    end

    permitted
  end
end