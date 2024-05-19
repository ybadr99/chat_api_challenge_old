class AddIndexesToChatsAndMessages < ActiveRecord::Migration[7.1]
  def change
    unless index_exists?(:chats, [:application_id, :number])
      add_index :chats, [:application_id, :number], unique: true
    end
    add_index :chats, :application_id unless index_exists?(:chats, :application_id)

    unless index_exists?(:messages, [:chat_id, :number])
      add_index :messages, [:chat_id, :number], unique: true
    end
    add_index :messages, :chat_id unless index_exists?(:messages, :chat_id)
  end
end
