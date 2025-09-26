class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true         # 通知を受けるユーザー
      t.references :actor, null: false, foreign_key: { to_table: :users } # 誰がアクションを起こしたか
      t.string :action                                         # "liked", "commented" など
      t.references :notifiable, polymorphic: true              # 対象のモデル
      t.boolean :read, default: false                          # 既読フラグ

      t.timestamps
    end
  end
end
