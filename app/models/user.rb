class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_one_attached :avatar
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_works, through: :likes, source: :work

  validates :display_name, length: { maximum: 50 }, allow_blank: true

  # display_nameカラムがあるので、メソッドは不要
  # もしdisplay_nameが空の場合のフォールバック
  def display_name_or_default
    display_name.presence || name.presence || email.split("@").first
  end
end