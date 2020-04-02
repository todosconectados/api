class AddNotificationSentToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notifications_sent, :integer, default: 0 
  end
end
