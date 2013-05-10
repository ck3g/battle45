class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :user
      t.string :status, null: false, default: 'start'

      t.timestamps
    end
    add_index :games, :user_id
    add_index :games, :status
  end
end
