class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.string :target_publisher

      t.timestamps
    end
  end
end
