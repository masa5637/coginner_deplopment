class AddEncryptedPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, null: false, default: ""
    end
  end
end
