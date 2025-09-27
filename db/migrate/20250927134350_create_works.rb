class CreateWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :works do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
