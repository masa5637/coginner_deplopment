class User < ApplicationRecord
  has_secure_password

  has_one :profile, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
