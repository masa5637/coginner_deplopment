class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor
  belongs_to :notifiable, polymorphic: true
end
