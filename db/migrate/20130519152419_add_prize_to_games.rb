class AddPrizeToGames < ActiveRecord::Migration
  def change
    add_column :games, :prize, :string
  end
end
