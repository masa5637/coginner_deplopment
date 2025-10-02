class Work < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :work_tags, dependent: :destroy
  has_many :tags, through: :work_tags

  has_many_attached :images

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(auth_object = nil)
    ["title", "description", "created_at", "updated_at"]
  end

  # Ransackで検索可能な関連を定義
  def self.ransackable_associations(auth_object = nil)
    ["user", "tags"]
  end
end