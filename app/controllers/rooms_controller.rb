class RoomsController < ApplicationController
  before_action :authenticate_user!

  # DM一覧
  def index
    @rooms = Room
      .joins(:room_users)
      .where(room_users: { user_id: current_user.id })
      .distinct
  end

  # DMルーム表示
  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user)
    @message = Message.new
  end

  # DM開始
  def create
    user = User.find(params[:user_id])

    # 既存ルームがあれば取得
    room = Room.joins(:room_users)
               .where(room_users: { user_id: [current_user.id, user.id] })
               .group("rooms.id")
               .having("COUNT(rooms.id) = 2")
               .first

    # なければ作成
    unless room
      room = Room.create!
      RoomUser.create!(room: room, user: current_user)
      RoomUser.create!(room: room, user: user)
    end

    redirect_to room_path(room)
  end

  # DMルーム削除
  def destroy
    room = Room.find(params[:id])

    if room.users.include?(current_user)
      room.destroy
      flash[:notice] = "DMルームを削除しました"
    else
      flash[:alert] = "権限がありません"
    end

    redirect_to rooms_path
  end
end
