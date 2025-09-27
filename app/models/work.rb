class Work < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags

  has_one_attached :image
end