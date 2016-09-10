class AddBusinessToGame < ActiveRecord::Migration
  def change
    add_column :games, :business_id, :integer
  end
end
