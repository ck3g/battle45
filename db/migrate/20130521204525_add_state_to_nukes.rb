class AddStateToNukes < ActiveRecord::Migration
  def change
    add_column :nukes, :state, :string
  end
end
