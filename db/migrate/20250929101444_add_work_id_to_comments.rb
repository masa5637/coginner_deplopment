class AddWorkIdToComments < ActiveRecord::Migration[7.1]
  def change
    add_reference :comments, :work, null: false, foreign_key: true
  end
end
