class AddGameToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :game_id, :integer
  end
end
