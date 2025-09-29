class AddWorkToLikes < ActiveRecord::Migration[7.1]
  def change
    add_reference :likes, :work, null: false, foreign_key: true
  end
end
