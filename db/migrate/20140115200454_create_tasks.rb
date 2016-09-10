class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :source_type
      t.string :rule_type
      t.string :rule_operand
      t.integer :goal_count
      t.integer :level_id
      t.timestamps
    end
  end
end
