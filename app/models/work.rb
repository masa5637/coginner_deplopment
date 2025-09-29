class Work < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags

  has_many_attached :images
end