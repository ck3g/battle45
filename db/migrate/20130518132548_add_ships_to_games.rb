class AddShipsToGames < ActiveRecord::Migration
  def change
    add_column :games, :ships, :string_array
  end
end
