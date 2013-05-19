class CreateNukes < ActiveRecord::Migration
  def change
    create_table :nukes do |t|
      t.references :game
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :target, null: false

      t.timestamps
    end
    add_index :nukes, :game_id
  end
end
