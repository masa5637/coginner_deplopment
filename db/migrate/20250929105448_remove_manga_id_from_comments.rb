class RemoveMangaIdFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :manga_id, :integer
  end
end
