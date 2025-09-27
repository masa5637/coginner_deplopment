class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :work, null: false, foreign_key: true
      t.text :content, null: false
      t.boolean :blocked, default: false

      t.timestamps
    end
  end
end
