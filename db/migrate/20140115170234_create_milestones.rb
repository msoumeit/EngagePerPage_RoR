class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :player_id
      t.integer :level_id
      t.integer :isPuzzleComplete
      t.integer :isTaskComplete
      t.string :art_id
      t.timestamps
    end
  end
end
