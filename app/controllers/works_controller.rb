class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index
    @q = Work.ransack(params[:q])

    if params[:q].present?
      # 検索条件がある場合はransackの結果を返す
      @works = @q.result(distinct: true).includes(:user, :tags)
    else
      # 検索条件がない場合は全作品を返す
      @works = Work.includes(:user, :tags).all
    end
  end

  def show
    @show_share_button = true
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params.except(:images))
    @work.user = current_user # 必須なら

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
    # @work は before_action で取得済み
  end

  def update
    if @work.update(work_params.except(:images))
      # 追加の画像があればattach
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

    # images 配列の中の空文字を削除
    if permitted[:images]
      permitted[:images].reject!(&:blank?)
    end

    permitted
  end
end
