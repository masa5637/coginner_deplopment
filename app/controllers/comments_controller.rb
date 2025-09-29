class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @work.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to work_path(@work), notice: "コメントを投稿しました"
    else
      render "works/show", status: :unprocessable_entity
    end
  end

  def edit
    @work = Work.find(params[:work_id])
    @comment = @work.comments.find(params[:id])
    render :edit, layout: false
  end

  def update
    if @comment.update(comment_params)
      redirect_to work_path(@work), notice: "コメントを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to work_path(@work), notice: "コメントを削除しました"
  end

  private

  def set_work
    @work = Work.find(params[:work_id])
  end

  def set_comment
    @comment = @work.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
