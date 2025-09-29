class RemoveMangaIdFromLikes < ActiveRecord::Migration[7.1]
  def change
    remove_column :likes, :manga_id, :integer
  end
end
