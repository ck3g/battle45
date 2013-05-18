class AddRemoteIdToGames < ActiveRecord::Migration
  def change
    add_column :games, :remote_id, :integer
    add_index :games, :remote_id, :unique => true
  end
end
