class EditUsernameColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :username
    add_column :users, :user_name, :string, null: false
  end
end
