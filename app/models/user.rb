class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_one :profile, dependent: :destroy
  has_one_attached :avatar
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_works, through: :likes, source: :work

  # フォロー関連
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # バリデーション
  validates :display_name, length: { maximum: 50 }, allow_blank: true

  # display_nameが空の場合のフォールバック
  def display_name_or_default
    display_name.presence || name.presence || email.split("@").first
  end

  # 指定したユーザーをフォロー
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  # 指定したユーザーをフォローしているかどうか
  def following?(user)
    followings.include?(user)
  end
end
