class CreateSessionTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :session_tokens do |t|
      t.string :token, null: false
      t.integer :user_id, null: false
      t.string :device
      t.timestamps
    end
      add_index :session_tokens, :token
      add_index :session_tokens, :user_id
  end
end
