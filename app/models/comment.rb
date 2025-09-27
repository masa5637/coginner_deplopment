class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :work

  scope :visible, -> { where(blocked: false) }
end